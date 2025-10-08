{
  lib,
  buildGo125Module,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
  nix-update-script,
  go_1_25,
}:
buildGo125Module (finalAttrs: {
  pname = "sshwifty";
  version = "0.4.1-beta-release";

  src = fetchFromGitHub {
    owner = "nirui";
    repo = "sshwifty";
    tag = finalAttrs.version;
    hash = "sha256-Kg5aE4lkzSedo+VJgdsfO5XTKupsPU2DhZNdNhEQ/Q4=";
  };

  sshwifty-ui = buildNpmPackage {
    pname = "sshwifty-ui";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-vX3CtjwjzcxxIPYG6QXsPybyBRow1YdS9pHr961P1HA=";

    npmBuildScript = "generate";

    postInstall = ''
      cp -r application/controller/{static_pages,static_pages.go} \
        $out/lib/node_modules/sshwifty-ui/application/controller
    '';

    nativeBuildInputs = [ go_1_25 ];
  };

  postPatch = ''
    cp -r ${finalAttrs.sshwifty-ui}/lib/node_modules/sshwifty-ui/* .
  '';

  vendorHash = "sha256-/SLUC0xM195QfKgX9te8UP1bbzRbKF+Npyugi19JijY=";

  ldflags = [
    "-s"
    "-X github.com/nirui/sshwifty/application.version=${finalAttrs.version}"
  ];

  postInstall = ''
    find $out/bin ! -name sshwifty -type f -exec rm -rf {} \;
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) sshwifty; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version=unstable"
        "--version-regex=^([0-9.]+(?!.+-prebuild).+$)"
        "--subpackage"
        "sshwifty-ui"
      ];
    };
  };

  meta = {
    description = "WebSSH & WebTelnet client";
    homepage = "https://github.com/nirui/sshwifty";
    changelog = "https://github.com/nirui/sshwifty/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sshwifty";
  };
})
