{
  lib,
  fetchFromGitHub,
  # Requires Go 1.26, drop when that's the default.
  buildGo126Module,
  nix-update-script,
  versionCheckHook,
  applyPatches,
}:

buildGo126Module (finalAttrs: {
  pname = "athens";
  version = "0.17.0";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "gomods";
      repo = "athens";
      tag = "v${finalAttrs.version}";
      hash = "sha256-4KCPYqLtqz46zr5+LB4CyG4ZQrjQaPgMEhCuGOWIJKg=";
    };
    # Trim the patch version, not needed anyway.
    postPatch = ''
      sed -i 's/go 1.26.2/go 1.26/' go.mod
    '';
  };

  vendorHash = "sha256-he7GNkCfqLgOXuCTahvqOnwW5TpbYjlCMfMGfKGwYZ4=";

  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X github.com/gomods/athens/pkg/build.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/proxy" ];

  postInstall = ''
    mv $out/bin/proxy $out/bin/athens
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go module datastore and proxy";
    homepage = "https://github.com/gomods/athens";
    changelog = "https://github.com/gomods/athens/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "athens";
    maintainers = with lib.maintainers; [
      katexochen
      malt3
    ];
    platforms = lib.platforms.unix;
  };
})
