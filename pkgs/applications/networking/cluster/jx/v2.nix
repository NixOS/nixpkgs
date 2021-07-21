{ callPackage, installShellFiles }:

let
  buildJX = callPackage ./jx.nix {};
  version = "2.1.155";
  rev = "v"+version;
in
  buildJX {
    pname = "jx-2";
    inherit version;
    sha256 = "sha256-kwcmZSOA26XuSgNSHitGaMohalnLobabXf4z3ybSJtk=";
    vendorSha256 = "1f2gdjg3ss54i0dk4ws8p0r0c48i4lcs038m4yb4qx4113sckh4g";
    subPackages = [ "cmd/jx" ];
    buildFlagsArray = [
      "-ldflags= -X github.com/jenkins-x/jx/pkg/cmd/version.Version=${version}
      -X github.com/jenkins-x/jx/pkg/cmd/version.Revision=${rev}
      -X github.com/jenkins-x/jx/pkg/cmd/version.GitTreeState=clean"
      ];
    nativeBuildInputs = [ installShellFiles ];
    postInstall = [
      "for shell in bash zsh; do
        $out/bin/jx completion $shell > jx.$shell
        installShellCompletion jx.$shell
      done"
    ];
  }
