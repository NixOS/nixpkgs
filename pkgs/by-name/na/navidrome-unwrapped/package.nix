{
  buildGo127Module,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nodejs_24,
  npmHooks,
  pkg-config,
  stdenv,
  taglib,
  zlib,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "navidrome";
  version = "0.64.2";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6667wi23YSPdF/LL5k7VmYEAM5rxQYjqlvAtg5vJzj4=";
  };

  patches = [
    ./6221.patch
  ];

  strictDeps = true;
  __structuredAttrs = true;

  vendorHash = "sha256-/3NhF/OHDxWrciN5GdROiO1yhjjdm5F5ntW7h6tzFGc=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    hash = "sha256-uRF9cf6HZE0gyCvGTEZ520d2gMsxmccEYLJBgc47pMg=";
  };

  nativeBuildInputs = [
    nodejs_24
    npmHooks.npmConfigHook
    pkg-config
  ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  buildInputs = [
    taglib
    zlib
  ];

  excludedPackages = [
    "plugins"
  ];

  ldflags = [
    "-X"
    "github.com/navidrome/navidrome/consts.gitSha=${finalAttrs.src.rev}"
    "-X"
    "github.com/navidrome/navidrome/consts.gitTag=v${finalAttrs.version}"
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    CGO_CFLAGS = toString [ "-Wno-return-local-addr" ];
  };

  postPatch = ''
    patchShebangs ui/bin/update-workbox.sh
  '';

  preBuild = ''
    make buildjs
  '';

  tags = [
    "netgo"
    "sqlite_fts5"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.navidrome = nixosTests.navidrome;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Music Server and Streamer compatible with Subsonic/Airsonic";
    mainProgram = "navidrome";
    homepage = "https://www.navidrome.org/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      aciceri
      tebriel
      RossSmyth
    ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.hostPlatform.isDarwin;
  };
})
