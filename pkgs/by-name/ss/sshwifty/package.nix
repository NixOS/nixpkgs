{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:
# Upstream updates regularly bump the minimum required Go version,
# so let's build using the latest Go available in nixpkgs.
buildGoLatestModule (finalAttrs: {
  pname = "sshwifty";
  version = "0.4.12-beta-release";

  src = fetchFromGitHub {
    owner = "nirui";
    repo = "sshwifty";
    tag = finalAttrs.version;
    hash = "sha256-zp/TqvjAb+yDOVkFXjXML/TxomIyPEG8fLq6BeDnSxU=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-t6g83QNq5hCNXPx5dcYYCaBJbjyXAao33qvdbZFCxvo=";
  };

  vendorHash = "sha256-fXQW97/ztjerM62rw1k1ZKD2LSBV2iKLZkk1hJ7HhXE=";

  preBuild = ''
    # Generate static pages
    npm run generate
  '';

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
      ];
    };
  };

  meta = {
    description = "WebSSH & WebTelnet client";
    homepage = "https://github.com/nirui/sshwifty";
    changelog = "https://github.com/nirui/sshwifty/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sshwifty";
  };
})
