{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  libopus,
  macdylibbundler,
  makeWrapper,
  darwin,
  codec2,
  libpulseaudio,
  libsamplerate,
  libsndfile,
  lpcnet,
  portaudio,
  speexdsp,
  hamlib_4,
  wxGTK32,
  sioclient,
  dbus,
  apple-sdk_15,
  nix-update-script,
}:

let
  ebur128Src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v1.2.6";
    hash = "sha256-UKO2k+kKH/dwt2xfaYMrH/GXjEkIrnxh1kGG/3P5d3Y=";
  };
  mimallocSrc = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.4";
    hash = "sha256-+8xZT+mVEqlqabQc+1buVH/X6FZxvCd0rWMyjPu9i4o=";
  };
  radaeSrc = fetchFromGitHub {
    owner = "drowe67";
    repo = "radae";
    rev = "2354cd2a4b3af60c7feb1c0d6b3d6dd7417c2ac9";
    hash = "sha256-yEr/OCXV83qXi89QHXMrUtQ2UwNOsijQMN35Or2JP+Y=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freedv";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-awWeq0ueKAK+4mAM0Nv3SsSv/mIFQ+/TqCPw9wjed1w=";
  };

  patches = [
    ./no-framework.patch
  ];

  postPatch = ''
    cp -R ${ebur128Src} ebur128
    cp -R ${mimallocSrc} mimalloc
    cp -R ${radaeSrc} radae
    chmod -R u+w ebur128 mimalloc radae
    substituteInPlace radae/cmake/BuildOpus.cmake \
      --replace-fail "https://gitlab.xiph.org/xiph/opus/-/archive/main/opus-main.tar.gz" "${libopus.src}" \
      --replace-fail "./autogen.sh && " ""
    substituteInPlace cmake/BuildEbur128.cmake \
      --replace-fail "GIT_REPOSITORY https://github.com/jiixyj/libebur128.git" "URL $(realpath ebur128)" \
      --replace-fail 'GIT_TAG "v''${EBUR128_VERSION}"' "" \
      --replace-fail "git apply" "patch -p1 <"
    substituteInPlace cmake/BuildMimalloc.cmake \
      --replace-fail "GIT_REPOSITORY https://github.com/microsoft/mimalloc.git" "URL $(realpath mimalloc)" \
      --replace-fail "GIT_TAG        v2.2.4" ""
    substituteInPlace cmake/BuildRADE.cmake \
      --replace-fail "GIT_REPOSITORY https://github.com/drowe67/radae.git" "URL $(realpath radae)" \
      --replace-fail "GIT_TAG main" ""
    patchShebangs test/test_*.sh
    substituteInPlace cmake/CheckGit.cmake \
      --replace-fail "git describe --abbrev=4 --always HEAD" "echo v${finalAttrs.version}"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "-Wl,-ld_classic" ""
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "\''${CMAKE_SOURCE_DIR}/macdylibbundler/dylibbundler" "dylibbundler"
    sed -i "/codesign/d;/hdiutil/d" src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (macdylibbundler.overrideAttrs {
      # incompatible with darwin.sigtool in Nixpkgs
      postPatch = ''
        substituteInPlace src/Utils.cpp \
          --replace-fail "--deep --preserve-metadata=entitlements,requirements,flags,runtime" ""
      '';
    })
    makeWrapper
    darwin.autoSignDarwinBinariesHook
    darwin.sigtool
  ];

  buildInputs = [
    codec2
    libsamplerate
    libsndfile
    lpcnet
    speexdsp
    hamlib_4
    wxGTK32
    sioclient
    python3.pkgs.numpy
  ]
  ++ (
    if stdenv.hostPlatform.isLinux then
      [
        libpulseaudio
        dbus
      ]
    else if stdenv.hostPlatform.isDarwin then
      [
        apple-sdk_15
      ]
    else
      [
        portaudio
      ]
  );

  cmakeFlags = [
    (lib.cmakeBool "USE_INTERNAL_CODEC2" false)
    (lib.cmakeBool "USE_STATIC_DEPS" false)
    (lib.cmakeBool "UNITTEST" true)
    (lib.cmakeBool "USE_NATIVE_AUDIO" (with stdenv.hostPlatform; isLinux || isDarwin))
  ];

  env.NIX_CFLAGS_COMPILE = "-I${codec2.src}/src";

  doCheck = false;

  postInstall = ''
    install -Dm755 rade_build/src/librade.* -t $out/lib
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/FreeDV.app $out/Applications
    makeWrapper $out/Applications/FreeDV.app/Contents/MacOS/FreeDV $out/bin/freedv
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # avoid pre‐releases
      "--version-regex"
      ''^v(\d\.\d\.\d(\.\d)?)$''
    ];
  };

  meta = {
    homepage = "https://freedv.org/";
    description = "Digital voice for HF radio";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      mvs
      wegank
    ];
    platforms = lib.platforms.unix;
    mainProgram = "freedv";
  };
})
