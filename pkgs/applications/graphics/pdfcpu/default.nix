{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-E1D2DvwwrtlY06kvCZkoAO5VcdtkBJYLcxuqGsulFUA=";
    # Apparently upstream requires that the compiled executable will know the
    # commit hash and the date of the commit. This information is also presented
    # in the output of `pdfcpu version` which we use as a sanity check in the
    # installCheckPhase. This was discussed upstream in:
    #
    # - https://github.com/pdfcpu/pdfcpu/issues/751
    # - https://github.com/pdfcpu/pdfcpu/pull/752
    #
    # The trick used here is to write that information into files in `src`'s
    # `$out`, and then read them into the `ldflags`. We also delete the `.git`
    # directories in `src`'s $out afterwards, imitating what's done if
    # `leaveDotGit = false;` See also:
    # https://github.com/NixOS/nixpkgs/issues/8567
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > $out/SOURCE_DATE
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-4k4aZnQ9SjcGr/ziCacfcVfVk7w4Qhli2rOeYE76Qs0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE)"
  '';


  # No tests
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    export HOME=$(mktemp -d)
    echo checking the version print of pdfcpu
    $out/bin/pdfcpu version | grep ${version}
    $out/bin/pdfcpu version | grep $(cat COMMIT | cut -c1-8)
    $out/bin/pdfcpu version | grep $(cat SOURCE_DATE)
  '';

  subPackages = [ "cmd/pdfcpu" ];

  meta = with lib; {
    description = "A PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "pdfcpu";
  };
}
