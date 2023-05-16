{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, copyDesktopItems
, gettext
, glib
, gtk3
, libGLU
, libdrm
, libepoxy
, libpcap
, libsamplerate
<<<<<<< HEAD
, libslirp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, makeDesktopItem
, mesa
, meson
, ninja
, openssl
, perl
, pkg-config
, python3
, vte
, which
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xemu";
<<<<<<< HEAD
  version = "0.7.111";
=======
  version = "0.7.88";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xemu-project";
    repo = "xemu";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-j7VNNKGm8mFEz+8779ylw1Yjd+jDuoL19Sw52kJll4s=";
=======
    hash = "sha256-rV90ISPaipczaJgGj0vAO1IJYDMJpncVGOdllO3Km2k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    copyDesktopItems
    meson
    ninja
    perl
    pkg-config
    python3
    python3.pkgs.pyyaml
    which
    wrapGAppsHook
  ];

  buildInputs = [
    SDL2
    SDL2_image
    gettext
    glib
    gtk3
    libGLU
    libdrm
    libepoxy
    libpcap
    libsamplerate
<<<<<<< HEAD
    libslirp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mesa
    openssl
    vte
  ];

  separateDebugInfo = true;

  dontUseMesonConfigure = true;

  setOutputFlags = false;

  configureFlags = [
    "--disable-strip"
    "--meson=meson"
    "--target-list=i386-softmmu"
    "--disable-werror"
  ];

  buildFlags = [ "qemu-system-i386" ];

  desktopItems = [
    (makeDesktopItem {
      name = "xemu";
      desktopName = "xemu";
      exec = "xemu";
      icon = "xemu";
    })
  ];

  preConfigure = ''
    patchShebangs .
    configureFlagsArray+=("--extra-cflags=-DXBOX=1 -Wno-error=redundant-decls")
    substituteInPlace ./scripts/xemu-version.sh \
      --replace 'date -u' "date -d @$SOURCE_DATE_EPOCH '+%Y-%m-%d %H:%M:%S'"
    # When the data below can't be obtained through git, the build process tries
    # to run `XEMU_COMMIT=$(cat XEMU_COMMIT)` (and similar)
    echo '${finalAttrs.version}' > XEMU_VERSION
  '';

  preBuild = ''
    cd build
    substituteInPlace ./build.ninja --replace /usr/bin/env $(which env)
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -T qemu-system-i386 $out/bin/xemu
  '' +
  # Generate code to install the icons
  (lib.concatMapStringsSep ";\n"
    (res:
      "install -Dm644 -T ../ui/icons/xemu_${res}.png $out/share/icons/hicolor/${res}/apps/xemu.png")
    [ "16x16" "24x24" "32x32" "48x48" "128x128" "256x256" "512x512" ]) +
  ''

    runHook postInstall
  '';

  meta = {
    homepage = "https://xemu.app/";
    description = "Original Xbox emulator";
    longDescription = ''
      A free and open-source application that emulates the original Microsoft
      Xbox game console, enabling people to play their original Xbox games on
      Windows, macOS, and Linux systems.
    '';
    changelog = "https://github.com/xemu-project/xemu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres genericnerdyusername ];
<<<<<<< HEAD
    platforms = lib.platforms.linux;
    mainProgram = "xemu";
=======
    platforms = with lib.platforms; linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
})
