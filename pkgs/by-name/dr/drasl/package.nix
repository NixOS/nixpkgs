{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  go-swag,
  nodejs,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "drasl";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "unmojang";
    repo = "drasl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fkSprGAY6X7+8B3J44kDHWzEkw8eeA4bsQPt3nDrC9k=";
  };

  nativeBuildInputs = [
    go-swag
    nodejs
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-1aIP/EKKC8+uwl48Lkw6k+S5l9s8sbALTQXWkyw5N0E=";
  };

  vendorHash = "sha256-6MFH6Tj1XBIwiVkG/wmDe0KJ6E9E0iaxWl5UzCiz34k=";

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  postPatch = ''
    substituteInPlace build_config.go --replace-fail "\"/usr/share/drasl\"" "\"$out/share/drasl\""
  '';

  preBuild = ''
    make prebuild
  '';

  postInstall = ''
    mkdir -p "$out/share/drasl"
    cp -R ./{assets,view,public,locales} "$out/share/drasl"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Alternative API server for Minecraft";
    homepage = "https://github.com/unmojang/drasl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      evan-goode
      ungeskriptet
    ];
    mainProgram = "drasl";
  };
})
