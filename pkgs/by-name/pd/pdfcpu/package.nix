{
  lib,
  buildGoModule,
  stdenv,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = "pdfcpu";
    tag = "v${version}";
    hash = "sha256-0xsa7/WlqjRMP961FTonfty40+C1knI3szCmCDfZJ/0=";
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

  vendorHash = "sha256-wZYYIcPhyDlmIhuJs91EqPB8AjLIDHz39lXh35LHUwQ=";

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
  installCheckInputs = [
    writableTmpDirAsHomeHook
  ];
  # NOTE: Can't use `versionCheckHook` since a writeable $HOME is required and
  # `versionCheckHook` uses --ignore-environment
  installCheckPhase = ''
    echo checking the version print of pdfcpu
    mkdir -p $HOME/"${
      if stdenv.hostPlatform.isDarwin then "Library/Application Support" else ".config"
    }"/pdfcpu
    versionOutput="$($out/bin/pdfcpu version)"
    for part in ${version} $(cat COMMIT | cut -c1-8) $(cat SOURCE_DATE); do
      if [[ ! "$versionOutput" =~ "$part" ]]; then
          echo version output did not contain expected part $part . Output was:
          echo "$versionOutput"
          exit 3
      fi
    done
  '';

  subPackages = [ "cmd/pdfcpu" ];

  meta = with lib; {
    description = "PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "pdfcpu";
  };
}
