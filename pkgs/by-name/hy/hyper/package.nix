{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  atk,
  glib,
  pango,
  gdk-pixbuf,
  gtk3,
  cairo,
  freetype,
  fontconfig,
  dbus,
  libXi,
  libXcursor,
  libXdamage,
  libXrandr,
  libXcomposite,
  libXext,
  libXfixes,
  libXrender,
  libX11,
  libXtst,
  libXScrnSaver,
  libxcb,
  nss,
  nspr,
  alsa-lib,
  cups,
  expat,
  udev,
  libpulseaudio,
  at-spi2-atk,
  at-spi2-core,
  libxshmfence,
  libdrm,
  libxkbcommon,
  mesa,
  nixosTests,
}:

let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    gtk3
    atk
    glib
    pango
    gdk-pixbuf
    cairo
    freetype
    fontconfig
    dbus
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libxcb
    libXrender
    libX11
    libXtst
    libXScrnSaver
    nss
    nspr
    alsa-lib
    cups
    expat
    udev
    libpulseaudio
    at-spi2-atk
    at-spi2-core
    libxshmfence
    libdrm
    libxkbcommon
    mesa
  ];

in
stdenv.mkDerivation rec {
  pname = "hyper";
  version = "3.4.1";

  src = fetchurl {
    url = "https://github.com/vercel/hyper/releases/download/v${version}/hyper_${version}_amd64.deb";
    sha256 = "sha256-jEzZ6MWFaNXBS8CAzfn/ufMPpWcua9HhBFzetWMlH1Y=";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"

    ln -s "$out/opt/Hyper/hyper" "$out/bin/hyper"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/Hyper:\$ORIGIN" "$out/opt/Hyper/hyper"

    mv usr/* "$out/"

    substituteInPlace $out/share/applications/hyper.desktop \
      --replace "/opt/Hyper/hyper" "hyper"
  '';

  passthru.tests.test = nixosTests.terminal-emulators.hyper;

  dontPatchELF = true;
  meta = with lib; {
    description = "Terminal built on web technologies";
    homepage = "https://hyper.is/";
    maintainers = with maintainers; [
      puffnfresh
      fabiangd
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "hyper";
    broken = true; # Error: 'node-pty' failed to load
  };
}
