{
  lib,
  stdenv,
  fetchFromGitHub,
  cacert,
  autoconf,
  automake,
  libtool,
  cmake,
  pkg-config,
  macdylibbundler,
  makeWrapper,
  darwin,
  codec2,
  libpulseaudio,
  libsamplerate,
  libsndfile,
  lpcnet,
  openssl,
  portaudio,
  speexdsp,
  hamlib_4,
  wxwidgets_3_2,
  dbus,
  apple-sdk_15,
  nix-update-script,
  wget,
}:

let
  codec2' = codec2.override { freedvSupport = true; };
  freedvBackendSrc = fetchFromGitHub {
    owner = "tmiw";
    repo = "freedv-backend";
    rev = "v1.0.0";
    hash = "sha256-t1Bu9XaNRa9zQKEffC4fJxclvzcu9UPMY4Gzt0kTfAY=";
  };
  ebur128Src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v1.2.6";
    hash = "sha256-UKO2k+kKH/dwt2xfaYMrH/GXjEkIrnxh1kGG/3P5d3Y=";
  };
  opusSrc = fetchFromGitHub {
    owner = "xiph";
    repo = "opus";
    rev = "940d4e5af64351ca8ba8390df3f555484c567fbb";
    postFetch = ''
      cd $out
      export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      export SSL_CERT_FILE=$NIX_SSL_CERT_FILE
      dnn/download_model.sh "4ed9445b96698bad25d852e912b41495ddfa30c8dbc8a55f9cde5826ed793453"
      substituteInPlace autogen.sh \
        --replace-fail 'dnn/download_model.sh "4ed9445b96698bad25d852e912b41495ddfa30c8dbc8a55f9cde5826ed793453"' ""
    '';
    hash = "sha256-P84gjnuiQQBVBExJBY3sUbwo00lXY6HB+AMpx/oovRg=";
  };
  radaeSrc = fetchFromGitHub {
    owner = "freedv";
    repo = "rade_c";
    rev = "a36161bce0fb37daf3f4602344b095f6817dddb1";
    hash = "sha256-UixeatZpdcu/uQF+KKpivfPs5yMdLJtJhyMgu8zfMgI=";
  };
  rnnoiseSrc = fetchFromGitHub {
    owner = "xiph";
    repo = "rnnoise";
    rev = "70f1d256acd4b34a572f999a05c87bf00b67730d";
    nativeBuildInputs = [ wget ];
    postFetch = ''
      cd $out
      export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      export SSL_CERT_FILE=$NIX_SSL_CERT_FILE
      ./download_model.sh
      substituteInPlace autogen.sh \
        --replace-fail "./download_model.sh" ""
    '';
    hash = "sha256-t/AwOCuHb5Oahy1fDI3Sc9M08Xz3dSAavhYatRC1OIk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freedv";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nd0oOGiMrERviaGOtdOQ0KTSSL/+69Q2bRHjojBUknU=";
  };

  postPatch = ''
    cp -R ${freedvBackendSrc} freedv-backend
    chmod -R u+w freedv-backend
    substituteInPlace cmake/BuildFreeDVBackend.cmake \
      --replace-fail "GIT_REPOSITORY https://github.com/tmiw/freedv-backend" "URL $(realpath freedv-backend)" \
      --replace-fail "GIT_TAG v1.0.0" ""
    cp -R ${ebur128Src} freedv-backend/ebur128
    cp -R ${radaeSrc} freedv-backend/radae
    cp -R ${rnnoiseSrc} freedv-backend/rnnoise
    chmod -R u+w freedv-backend/ebur128 freedv-backend/radae freedv-backend/rnnoise
    substituteInPlace freedv-backend/cmake/BuildEbur128.cmake \
      --replace-fail "GIT_REPOSITORY https://github.com/jiixyj/libebur128.git" "URL $(realpath freedv-backend/ebur128)" \
      --replace-fail 'GIT_TAG "v''${EBUR128_VERSION}"' "" \
      --replace-fail "git apply" "patch -p1 <"
    substituteInPlace freedv-backend/cmake/BuildRADE.cmake \
      --replace-fail "https://github.com/xiph/opus/archive/940d4e5af64351ca8ba8390df3f555484c567fbb.zip" "${opusSrc}" \
      --replace-fail "GIT_REPOSITORY https://github.com/freedv/rade_c" "URL $(realpath freedv-backend/radae)" \
      --replace-fail "GIT_TAG main" ""
    substituteInPlace freedv-backend/cmake/BuildRNNoise.cmake \
      --replace-fail "GIT_REPOSITORY \''${RNNOISE_REPO}" "URL $(realpath freedv-backend/rnnoise)" \
      --replace-fail "GIT_TAG main" ""

    patchShebangs test/test_*.sh
    substituteInPlace cmake/CheckGit.cmake \
      --replace-fail "git describe --abbrev=4 --always HEAD" "echo v${finalAttrs.version}"

    substituteInPlace CMakeLists.txt \
      --replace-fail "-Wl,-ld_classic" ""
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "\''${CMAKE_SOURCE_DIR}/macdylibbundler/dylibbundler" "dylibbundler"
    sed -i "/codesign/d;/hdiutil/d" src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    cmake
    pkg-config
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
    codec2'
    libsamplerate
    libsndfile
    lpcnet
    speexdsp
    hamlib_4
    wxwidgets_3_2
    openssl
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

  env.NIX_CFLAGS_COMPILE = "-I${codec2'.src}/src";

  doCheck = false;

  postInstall =
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      install -Dm755 _deps/freedv_backend-build/rade_build/src/librade.* -t $out/lib
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
