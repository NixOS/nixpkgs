{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  gitMinimal,
  pkg-config,
  python3,
  cairo,
  libsndfile,
  libxcb,
  libxkbcommon,
  xcbutil,
  xcbutilcursor,
  xcbutilkeysyms,
  zenity,
  curl,
  rsync,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surge";
  version = "1.9.0";

  src = fetchurl {
    url = "https://github.com/surge-synthesizer/releases/releases/download/${finalAttrs.version}/SurgeSrc_${finalAttrs.version}.tgz";
    hash = "sha256-k7x+s84OpazARlHWXEP1aC57+o3uEduAzYDeyBwlTgE=";
  };

  extraContent = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge-extra-content";
    # rev from: https://github.com/surge-synthesizer/surge/blob/release_1.8.1/cmake/stage-extra-content.cmake#L6
    # or: https://github.com/surge-synthesizer/surge/blob/main/cmake/stage-extra-content.cmake
    # SURGE_EXTRA_CONTENT_HASH
    rev = "afc591cc06d9adc3dc8dc515a55c66873fa10296";
    hash = "sha256-/3wrsA7aG7Jb4ehhnKRJ6hAH0Ir5EAvCypRbcKhBG/M=";
  };

  patches = [
    # Fix build error due to newer glibc version by upgrading lib "catch 2"
    # Issue: https://github.com/surge-synthesizer/surge/pull/4843
    # Patch: https://github.com/surge-synthesizer/surge/pull/4845
    (fetchpatch {
      url = "https://github.com/surge-synthesizer/surge/commit/7a552038bab4b000d188ae425aa97963dc91db17.patch";
      hash = "sha256-5Flf0uJqEK6e+sadB+vr6phdvvdZYXcFFfm4ywhAeW0=";
      name = "glibc_build_fix.patch";
    })
  ];

  nativeBuildInputs = [
    cmake
    gitMinimal
    pkg-config
    python3
  ];

  buildInputs = [
    cairo
    libsndfile
    libxcb
    libxkbcommon
    xcbutil
    xcbutilcursor
    xcbutilkeysyms
    zenity
    curl
    rsync
  ];

  postPatch = ''
    substituteInPlace src/common/SurgeStorage.cpp \
      --replace "/usr/share/Surge" "$out/share/surge"
    substituteInPlace src/linux/UserInteractionsLinux.cpp \
      --replace '"zenity' '"${zenity}/bin/zenity'
    patchShebangs scripts/linux/
    cp -r $extraContent/Skins/ resources/data/skins
  '';

  installPhase = ''
    cd ..
    cmake --build build --config Release --target install-everything-global
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    export HOME=$(mktemp -d)
    export SURGE_DISABLE_NETWORK_TESTS=TRUE
    build/surge-headless
  '';

  meta = {
    description = ''
      LV2 & VST3 synthesizer plug-in (previously released as Vember Audio
      Surge)
    '';
    homepage = "https://surge-synthesizer.github.io";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      magnetophon
      orivej
    ];
  };
})
