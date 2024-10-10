{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  writeShellScript,
  ...
}:
let
  pname = "cloudpan189-go";
  version = "0.1.3";
  cmd = buildGoModule {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "tickstep";
      repo = "cloudpan189-go";
      rev = "v${version}";
      fetchSubmodules = false;
      sha256 = "sha256-CJCTfzcLw5e41RZXhgbJhZVOP4FDDYM74Oo9my/liZk=";
    };

    vendorHash = "sha256-6t4wJqUGJneR6Hv7Dotr4P9MTA1oQcCe/ujDojS0g8s=";

    # Dirty way to fix dependency issue
    overrideModAttrs = _: {
      postInstall = ''
        sed -i '/go:linkname/d' $out/github.com/tickstep/library-go/expires/expires.go
      '';
    };

    doCheck = false;
  };

  startScript = writeShellScript "cloudpan189-go" ''
    export CLOUD189_CONFIG_DIR=''${HOME}/.config/cloudpan189-go
    mkdir -p ''${CLOUD189_CONFIG_DIR}
    exec ${cmd}/bin/cloudpan189-go "$@"
  '';
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  postInstall = ''
    install -Dm755 ${startScript} $out/bin/cloudpan189-go
  '';

  meta = with lib; {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "CLI for China Telecom 189 Cloud Drive service, implemented in Go";
    homepage = "https://github.com/tickstep/cloudpan189-go";
    license = licenses.asl20;
  };
}
