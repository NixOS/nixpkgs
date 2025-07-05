{
  buildGo124Module,
  buildPackages,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nodejs,
  npmHooks,
  pkg-config,
  stdenv,
  ffmpeg-headless,
  taglib,
  zlib,
  nixosTests,
  nix-update-script,
  ffmpegSupport ? true,
}:

buildGo124Module rec {
  pname = "navidrome";
  version = "0.57.0";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    hash = "sha256-KTgh+dA2YYPyNdGr2kYEUlYeRwNnEcSQlpQ7ZTbAjP0=";
  };

  vendorHash = "sha256-/WeEimHCEQbTbCZ+4kXVJdHAa9PJEk1bG1d2j3V9JKM=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/ui";
    hash = "sha256-tl6unHz0E0v0ObrfTiE0vZwVSyVFmrLggNM5QsUGsvI=";
  };

  nativeBuildInputs = [
    buildPackages.makeWrapper
    nodejs
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

  ldflags = [
    "-X github.com/navidrome/navidrome/consts.gitSha=${src.rev}"
    "-X github.com/navidrome/navidrome/consts.gitTag=v${version}"
  ];

  CGO_CFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-return-local-addr" ];

  postPatch = ''
    patchShebangs ui/bin/update-workbox.sh
  '';

  patches = [
    # Until https://github.com/navidrome/navidrome/pull/4302 is released
    ./0001-test-fix-Use-bin-sh-as-mock_mpv.sh-interpreter-4301.patch
  ];

  preBuild = ''
    make buildjs
  '';

  tags = [
    "netgo"
  ];

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  passthru = {
    tests.navidrome = nixosTests.navidrome;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    mainProgram = "navidrome";
    homepage = "https://www.navidrome.org/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      aciceri
      squalus
      tebriel
    ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.hostPlatform.isDarwin;
  };
}
