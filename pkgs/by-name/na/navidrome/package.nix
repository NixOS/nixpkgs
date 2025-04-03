{
  buildGo123Module,
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

buildGo123Module rec {
  pname = "navidrome";
  version = "0.55.1";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    hash = "sha256-BkgHUX2kQ7OMnb9vOIwsQ9eNcqCzekz2IVMtG0IMUaA=";
  };

  vendorHash = "sha256-IF2RaEsuHADnwONrvwbL6KZVrE3bZx1sX03zpmtQZq8=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/ui";
    hash = "sha256-lM8637tcKc9iSPjXJPDZXFCGj7pShOXTC6X2iketg90=";
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
    ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.hostPlatform.isDarwin;
  };
}
