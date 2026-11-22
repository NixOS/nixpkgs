{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cacert,
  gitUpdater,
  unstableGitUpdater,
  cctools,
  pkg-config,
  zlib,
  ffmpeg-headless,
  freetype,
  libjpeg_turbo,
  libpng,
  libmad,
  faad2,
  libogg,
  libvorbis,
  libtheora,
  a52dec,
  nghttp2,
  openjpeg,
  libcaca,
  mesa_glu,
  xvidcore,
  openssl,
  jack2,
  alsa-lib,
  pulseaudio,
  SDL2,
  curl,
  libxv,
  libx11,
  xorgproto,

  withFullDeps ? false,
  withFfmpeg ? withFullDeps,
  releaseChannel ? "stable",
}:

let
  stable = rec {
    version = "26.07.0";
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "v${version}";
      hash = "sha256-L4GKXCFsKVxWXZJJeiAegXJySoS9+/V+/cuzEJEse+I=";
    };
    patches = [
      (fetchpatch2 {
        name = "CVE-2026-103227.patch";
        url = "https://github.com/gpac/gpac/commit/24e52d0a6001671ab61310105a24e2874e289a24.patch?full_index=1";
        hash = "sha256-vh7Sb81W3lFHz8SJBfDTaMZyI6bpBLpB8oP39EpBp3o=";
      })
      (fetchpatch2 {
        name = "CVE-2026-124030.patch";
        url = "https://github.com/gpac/gpac/commit/1359c4da9329cedceeb8fcfeab6d97e0927236e1.patch?full_index=1";
        hash = "sha256-3W4jIehmw5WNavGJzYkulo8Oq8zna6uBc/k+1TrbuF8=";
      })
      (fetchpatch2 {
        name = "CVE-2026-124031.patch";
        url = "https://github.com/gpac/gpac/commit/43a8329a90ae2907716b593cc3746458516c7c39.patch?full_index=1";
        hash = "sha256-ZUzxhLe/vqCT1xuliJLXMF4q5hedYMmQQCppmy1ilAk=";
      })
      (fetchpatch2 {
        name = "CVE-2026-108538.patch";
        url = "https://github.com/gpac/gpac/commit/563859e5f9f1640893267a7d4e0e185e81654734.patch?full_index=1";
        hash = "sha256-L2WCfX0Ieue0+WY7Pu83wtM0REJa4mSxG8iQffQ/aIc=";
      })
      (fetchpatch2 {
        name = "CVE-2026-128239.patch";
        url = "https://github.com/gpac/gpac/commit/6ef6bc65dd2b9d4c2e78806b9c122c549f82298a.patch?full_index=1";
        hash = "sha256-PKBaD9IojN3PFAY6Ccqd9BGFKRPiv+I7RffcJYvywcE=";
      })
      (fetchpatch2 {
        name = "CVE-2026-128240.patch";
        url = "https://github.com/gpac/gpac/commit/83585cafbb1292b075e3f59dcb4083706d724f35.patch?full_index=1";
        hash = "sha256-osvBvF+DzRqx3mT32EXyVSd+mKS2pdszAeN9QcajtcQ=";
      })
    ];
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "^(abi|test)";
    };
  };
  unstable = {
    version = "26.07.0-unstable-2026-11-18";
    src = fetchFromGitHub {
      owner = "gpac";
      repo = "gpac";
      rev = "f1991b1b0437182b66e710a4da22d8f081c76c95";
      hash = "sha256-BTM7RAXFZtiGEIVqLZnYckhMYkglf2yr1DhsIWyjdMg=";
    };
    updateScript = unstableGitUpdater {
      tagFormat = "v*";
      tagPrefix = "v";
    };
    patches = [ ];
  };
  channelToUse = if releaseChannel == "unstable" then unstable else stable;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gpac";
  inherit (channelToUse) version src patches;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ]
  ++ lib.optionals withFfmpeg [
    ffmpeg-headless
  ];

  # ref: https://wiki.gpac.io/Build/build/GPAC-Build-Guide-for-Linux/#gpac-easy-build-recommended-for-most-users
  buildInputs = [
    zlib
  ]
  ++ lib.optionals withFullDeps [
    freetype
    libjpeg_turbo
    libpng
    libmad
    faad2
    libogg
    libvorbis
    libtheora
    a52dec
    nghttp2
    openjpeg
    libcaca
    libx11
    libxv
    xorgproto
    mesa_glu
    xvidcore
    openssl
    jack2
    alsa-lib
    pulseaudio
    SDL2
    curl
  ];

  enableParallelBuilding = true;

  postInstall = ''
    rm $out/share/gpac/res/ca-bundle.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/share/gpac/res/ca-bundle.crt
  '';

  passthru.updateScript = channelToUse.updateScript;

  meta = {
    description = "Open Source multimedia framework for research and academic purposes";
    longDescription = ''
      GPAC is an Open Source multimedia framework for research and academic purposes.
      The project covers different aspects of multimedia, with a focus on presentation
      technologies (graphics, animation and interactivity) and on multimedia packaging
      formats such as MP4.

      GPAC provides three sets of tools based on a core library called libgpac:

      A multimedia player, called Osmo4 / MP4Client,
      A multimedia packager, called MP4Box,
      And some server tools included in MP4Box and MP42TS applications.
    '';
    homepage = "https://gpac.wp.imt.fr";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      mgdelacroix
      thesn
    ];
    platforms = lib.platforms.unix;
  };
})
