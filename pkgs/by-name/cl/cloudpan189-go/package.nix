{
  buildGo122Module,
  lib,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGo122Module rec {
  pname = "cloudpan189-go";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "tickstep";
    repo = "cloudpan189-go";
    rev = "v${version}";
    hash = "sha256-CJCTfzcLw5e41RZXhgbJhZVOP4FDDYM74Oo9my/liZk=";
  };
  vendorHash = "sha256-6t4wJqUGJneR6Hv7Dotr4P9MTA1oQcCe/ujDojS0g8s=";

  # Dirty way to fix dependency issue
  overrideModAttrs = _: {
    postInstall = ''
      sed -i '/go:linkname/d' $out/github.com/tickstep/library-go/expires/expires.go
    '';
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  postFixup = ''
    mv $out/bin/cloudpan189-go $out/bin/.cloudpan189-go-wrapped

    cat <<EOF >$out/bin/cloudpan189-go
    #!/bin/sh
    export CLOUD189_CONFIG_DIR="\''${CLOUD189_CONFIG_DIR:-\''${HOME}/.config/cloudpan189-go}"
    mkdir -p \''${CLOUD189_CONFIG_DIR}
    exec $out/bin/.cloudpan189-go-wrapped "\$@"
    EOF

    chmod +x $out/bin/cloudpan189-go
  '';

  meta = {
    mainProgram = "cloudpan189-go";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "CLI for China Telecom 189 Cloud Drive service, implemented in Go";
    homepage = "https://github.com/tickstep/cloudpan189-go";
    license = lib.licenses.asl20;
  };
}
