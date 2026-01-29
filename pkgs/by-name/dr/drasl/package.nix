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
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "unmojang";
    repo = "drasl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uh425i+SZZCFEUPVY/DvKARvwyAAjprQRzeiHVIcLHE=";
  };

  nativeBuildInputs = [
    go-swag
    nodejs
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-L0y04zLgno5kKUACyokma8uk/fNY2mwdMwsq217SCqI=";
  };

  vendorHash = "sha256-4Rk59bnDFYpraoGvkBUW6Z5fiXUmm2RLwS1wxScWAMQ=";

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
    description = "Yggdrasil-compatible API server for Minecraft";
    homepage = "https://github.com/unmojang/drasl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      evan-goode
      ungeskriptet
    ];
    mainProgram = "drasl";
  };
})
