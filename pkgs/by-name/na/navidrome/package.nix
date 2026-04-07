{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchpatch,
  lib,
  nodejs_24,
  npmHooks,
  pkg-config,
  stdenv,
  ffmpeg-headless,
  taglib,
  zlib,
  nixosTests,
  nix-update-script,
  ffmpegSupport ? true,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "navidrome";
  version = "0.61.1";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BRMJCBQl38AqsCI2UYQ9X36U57pg9uuiHsx8sHpVBKE=";
  };

  patches = [
    # https://github.com/navidrome/navidrome/pull/5276 (waiting on release)
    (fetchpatch {
      name = "regenerate-package-lock-json";
      url = "https://github.com/navidrome/navidrome/compare/v0.61.1...33a05ef662760fd9feb0a3ae43c7fe149eda610b.patch";
      hash = "sha256-IQ0wJ7vsSaLjBZS/fKIApNM8UV8oj6L2taCQIPhHvwg=";
    })
  ];

  vendorHash = "sha256-iVXJPP41rIpC6Tu1P/jWcePYCQ2Z9lEoTOrDLN26kTU=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src patches;
    # Remove after https://github.com/navidrome/navidrome/pull/5276 is released
    # patches are applied after we run npmDeps without inheriting patches here
    # so we have to get out of the sourceRoot to apply it then get back in to it
    prePatch = "cd ..";
    postPatch = "cd ui";
    sourceRoot = "${finalAttrs.src.name}/ui";
    hash = "sha256-iXey2XmDwsTR1/bIrBLzm6uvVGzPgQFcDLUtNy8robI=";
  };

  nativeBuildInputs = [
    buildPackages.makeWrapper
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
    "-X github.com/navidrome/navidrome/consts.gitSha=${finalAttrs.src.rev}"
    "-X github.com/navidrome/navidrome/consts.gitTag=v${finalAttrs.version}"
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

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

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
    ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.hostPlatform.isDarwin;
  };
})
