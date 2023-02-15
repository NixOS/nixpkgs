{ stdenv
, fetchFromGitHub
, lib
, makeDesktopItem
, copyDesktopItems
, pkg-config
, python3
, ninja
, meson
, which
, perl
, wrapGAppsHook
, glib
, gtk3
, libpcap
, openssl
, libepoxy
, libsamplerate
, SDL2
, SDL2_image
, mesa
, libdrm
, libGLU
, gettext
, vte
}:

stdenv.mkDerivation rec {
  pname = "xemu";
  version = "0.7.84";

  src = fetchFromGitHub {
    owner = "xemu-project";
    repo = "xemu";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-pEXjwoQKbMmVNYCnh5nqP7k0acYOAp8SqxYZwPzVwDY=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    python3.pkgs.pyyaml
    ninja
    which
    meson
    perl
    wrapGAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    glib
    gtk3
    openssl
    mesa
    libepoxy
    libdrm
    libpcap
    libsamplerate
    SDL2
    libGLU
    SDL2_image
    gettext
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

  desktopItems = [(makeDesktopItem {
    name = "xemu";
    desktopName = "xemu";
    exec = "xemu";
    icon = "xemu";
  })] ;

  preConfigure = let
    branch = "master";
    commit = "d8fa50e524c22f85ecb2e43108fd6a5501744351";
  in ''
    patchShebangs .
    configureFlagsArray+=("--extra-cflags=-DXBOX=1 -Wno-error=redundant-decls")
    substituteInPlace ./scripts/xemu-version.sh \
      --replace 'date -u' "date -d @$SOURCE_DATE_EPOCH '+%Y-%m-%d %H:%M:%S'"
    # If the versions can't be obtained through git, the build process tries
    # to run `XEMU_COMMIT=$(cat XEMU_COMMIT)` (and similar)
    echo '${commit}' > XEMU_COMMIT
    echo '${branch}' > XEMU_BRANCH
    echo '${version}' > XEMU_VERSION
  '';

  preBuild = ''
    cd build
    substituteInPlace ./build.ninja --replace /usr/bin/env $(which env)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp qemu-system-i386 $out/bin/xemu

    for RES in 16x16 24x24 32x32 48x48 128x128 256x256 512x512
    do
      mkdir -p $out/share/icons/hicolor/$RES/apps/
      cp ../ui/icons/xemu_$RES.png $out/share/icons/hicolor/$RES/apps/xemu.png
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://xemu.app/";
    description = "Original Xbox emulator";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
  };
}
