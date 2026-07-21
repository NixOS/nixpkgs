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
    owner = "peterbmarks";
    repo = "radae_nopy";
    rev = "d72ec84e795493249db44d5939eb9b05438f956a";
    hash = "sha256-ziEhYZarzQtQ1akAxF54kcX6o38gJeUJ08jipSWXnxQ=";
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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TjE/iYg+VFvbZH7/1q1V4t0SgcS44pLVet4Pgt6L5HA=";
  };

  postPatch = ''
    cp -R ${ebur128Src} ebur128
    cp -R ${radaeSrc} radae
    cp -R ${rnnoiseSrc} rnnoise
    chmod -R u+w ebur128 radae rnnoise
    substituteInPlace cmake/BuildEbur128.cmake \
      --replace-fail "GIT_REPOSITORY https://github.com/jiixyj/libebur128.git" "URL $(realpath ebur128)" \
      --replace-fail 'GIT_TAG "v''${EBUR128_VERSION}"' "" \
      --replace-fail "git apply" "patch -p1 <"
    substituteInPlace cmake/BuildRADE.cmake \
      --replace-fail "https://github.com/xiph/opus/archive/940d4e5af64351ca8ba8390df3f555484c567fbb.zip" "${opusSrc}" \
      --replace-fail "GIT_REPOSITORY https://github.com/peterbmarks/radae_nopy/" "URL $(realpath radae)" \
      --replace-fail "GIT_TAG main" ""
    substituteInPlace cmake/BuildRNNoise.cmake \
      --replace-fail "GIT_REPOSITORY \''${RNNOISE_REPO}" "URL $(realpath rnnoise)" \
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
