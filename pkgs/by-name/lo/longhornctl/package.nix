{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
,
}:
buildGoModule rec {
  pname = "longhornctl";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "longhorn";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-G0GJUtskJ99M5hCY5Ao+rbM8CAGMSOqbuDRhWSPJs8k=";
  };

  vendorHash = null;

  subPackages = [ "cmd/remote" ];

  ldflags = [
    "-X github.com/longhorn/cli/meta.Version=${version}"
    "-X github.com/longhorn/cli/meta.BuildDate=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    ln -s $out/bin/remote $out/bin/longhornctl
  '';

  passthru.tests = { inherit (nixosTests) longhornctl; };

  meta = {
    description = "a CLI (command-line interface) designed to simplify Longhorn manual operations.";
    downloadPage = "https://github.com/longhorn/cli";
    homepage = "https://longhorn.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ohmymndy
    ];
    mainProgram = "longhornctl";
  };
}
