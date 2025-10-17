{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  libsForQt5,
  libtool,
  pkg-config,
  unzip,

  # buildInputs
  c-ares,
  cryptopp,
  curl,
  ffmpeg,
  hicolor-icon-theme,
  icu,
  libmediainfo,
  libsodium,
  libuv,
  libxcb,
  libzen,
  openssl,
  readline,
  sqlite,
  wget,
  xorg,
  zlib,

  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "megasync";
  version = "5.16.0.2";

  src = fetchFromGitHub rec {
    owner = "meganz";
    repo = "MEGAsync";
    tag = "v${finalAttrs.version}_Linux";
    hash = "sha256-Bkye2Is3GbdnYYaS//AkNfrt8ppWP9zE58obcmUm0wE=";
    fetchSubmodules = false; # DesignTokensImporter cannot be fetched, see #1010 in github:meganz/megasync
    leaveDotGit = true;
    postFetch = ''
      cd $out

      git remote add origin $url
      git fetch origin
      git clean -fdx
      git checkout ${tag}
      git submodule update --init src/MEGASync/mega

      rm -rf .git
    ''; # Why so complicated, I just want a single submodule
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/020-megasync-sdk-fix-cmake-dependencies-detection.patch?h=megasync&id=ff59780039697591e7e3a966db058b23bee0451c";
      hash = "sha256-hQY6tMwiV3B6M6WiFdOESdhahAtuWjdoj2eI2mst/K8=";
      extraPrefix = "src/MEGASync/mega/";
      stripLen = true;
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/030-megasync-app-fix-cmake-dependencies-detection.patch?h=megasync&id=ff59780039697591e7e3a966db058b23bee0451c";
      hash = "sha256-11XWctv1veUEguc9Xvz2hMYw26CaCwu6M4hyA+5r81U=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/040-megasync-app-add-missing-link-to-zlib.patch?h=megasync&id=c1f647871f5aad7e421971165b07e51b3e7900e9";
      hash = "sha256-HMsS5TlzkQZbfANSIrvH8Cp6mTxLJ04idcWUWeD2A0U=";
    })
    ./megasync-fix-cmake-install-bindir.patch
    ./dont-fetch-clang-format.patch
  ];

  postPatch = ''
    substituteInPlace cmake/modules/desktopapp_options.cmake \
      --replace-fail "ENABLE_ISOLATED_GFX ON" "ENABLE_ISOLATED_GFX OFF"

    for file in $(find src/ -type f \( -iname configure -o -iname \*.sh \) ); do
      substituteInPlace "$file" --replace-warn "/bin/bash" "${stdenv.shell}"
    done
  '';

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
    libtool
    pkg-config
    unzip
  ];

  buildInputs = [
    c-ares
    cryptopp
    curl
    ffmpeg
    hicolor-icon-theme
    icu
    libmediainfo
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
    libsForQt5.qtgraphicaleffects
    libsForQt5.qtquickcontrols
    libsForQt5.qtquickcontrols2
    libsForQt5.qtsvg
    libsForQt5.qtx11extras
    libsodium
    libuv
    libxcb
    libzen
    openssl
    readline
    sqlite
    wget
    zlib
  ];

  dontUseQmakeConfigure = true;
  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "USE_PDFIUM" false) # PDFIUM is not in nixpkgs
    (lib.cmakeBool "USE_FREEIMAGE" false) # freeimage is insecure
    (lib.cmakeBool "ENABLE_DESIGN_TOKENS_IMPORTER" false) # cannot be fetched
    (lib.cmakeBool "USE_BREAKPAD" false)
    (lib.cmakeBool "ENABLE_DESKTOP_APP_TESTS" false)
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ xorg.xrdb ]})
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v(.*)_Linux$"
      ];
    };
  };

  meta = {
    description = "Easy automated syncing between your computers and your MEGA Cloud Drive";
    homepage = "https://mega.nz/";
    downloadPage = "https://github.com/meganz/MEGAsync";
    changelog = "https://github.com/meganz/MEGAsync/releases/tag/v${finalAttrs.version}_Linux";
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ iedame ];
    mainProgram = "megasync";
  };
})
