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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "unmojang";
    repo = "drasl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wSQEW6DJzualvG/xjMS9iv4j0SRKP6HWG0EliuE32ik=";
  };

  nativeBuildInputs = [
    go-swag
    nodejs
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-2Oc7Ib/hcAaqBOGFAWMbj/YWnYyskCgWgZ4Jyo6y+ck=";
  };

  vendorHash = "sha256-07VlwgzgeHX4W2HAYqKzIpGmq6kN/kprYZPUsCwqhiw=";

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
