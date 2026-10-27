{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
  applyPatches,
}:

buildGoModule (finalAttrs: {
  pname = "athens";
  version = "0.19.2";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "gomods";
      repo = "athens";
      tag = "v${finalAttrs.version}";
      hash = "sha256-e1vV3foK9fiJeTcYcgrNUnXB3Zo6XRq9HwVnY3OuIe0=";
    };
    # Trim the patch version, not needed anyway.
    postPatch = ''
      sed -i 's/go 1.26.2/go 1.26/' go.mod
    '';
  };

  vendorHash = "sha256-v1uJXiOeU4OtVHPFUgI7Lhu/AQqRcrSAH1VYo1d6EIQ=";

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
