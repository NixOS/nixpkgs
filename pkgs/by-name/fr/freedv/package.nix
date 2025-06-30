{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
  pulseSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  apple-sdk_15,
  nix-update-script,
}:

let
  radaeSrc = fetchFromGitHub {
    owner = "drowe67";
    repo = "radae";
    rev = "2354cd2a4b3af60c7feb1c0d6b3d6dd7417c2ac9";
    hash = "sha256-yEr/OCXV83qXi89QHXMrUtQ2UwNOsijQMN35Or2JP+Y=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freedv";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3vwFB+3LloumEAGlSJZc2+/I8uI6KLP/KuDGeDOj87k=";
  };

  patches = [
    ./no-framework.patch
  ];

  postPatch =
    ''
      cp -R ${radaeSrc} radae
      chmod -R u+w radae
      substituteInPlace radae/cmake/BuildOpus.cmake \
        --replace-fail "https://gitlab.xiph.org/xiph/opus/-/archive/main/opus-main.tar.gz" "${libopus.src}" \
        --replace-fail "./autogen.sh && " ""
      substituteInPlace cmake/BuildRADE.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/drowe67/radae.git" "URL $(realpath radae)" \
        --replace-fail "GIT_TAG main" ""
      patchShebangs test/test_*.sh
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "-Wl,-ld_classic" ""
      substituteInPlace src/CMakeLists.txt \
        --replace-fail "\''${CMAKE_SOURCE_DIR}/macdylibbundler/dylibbundler" "dylibbundler"
      sed -i "/codesign/d;/hdiutil/d" src/CMakeLists.txt
    '';

  nativeBuildInputs =
    [
      cmake
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      macdylibbundler
      makeWrapper
      darwin.autoSignDarwinBinariesHook
      darwin.sigtool
    ];

  buildInputs =
    [
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
    ++ (if pulseSupport then [ libpulseaudio ] else [ portaudio ])
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_15
    ];

  cmakeFlags = [
    (lib.cmakeBool "USE_INTERNAL_CODEC2" false)
    (lib.cmakeBool "USE_STATIC_DEPS" false)
    (lib.cmakeBool "UNITTEST" true)
    (lib.cmakeBool "USE_PULSEAUDIO" pulseSupport)
  ];

  env.NIX_CFLAGS_COMPILE = "-I${codec2.src}/src";

  doCheck = false;

  postInstall =
    ''
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
