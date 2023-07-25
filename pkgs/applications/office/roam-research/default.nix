{ stdenv, lib, fetchurl, alsa-lib, atk, cairo, cups, dbus, dpkg, expat
, gdk-pixbuf, glib, gtk3, libX11, libXScrnSaver, libXcomposite, libXcursor
, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, libdrm
, libpulseaudio, libxcb, libxkbcommon, libxshmfence, mesa, nspr, nss, pango
, udev, }:

let
  libPath = lib.makeLibraryPath [
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libdrm
    libxcb
    libxkbcommon
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    libXScrnSaver
    libXcursor
    libXrender
    libXtst
    libpulseaudio
    udev
  ];
in stdenv.mkDerivation rec {
  pname = "roam-research";
  version = "0.0.18";

  src = fetchurl {
    url =
      "https://roam-electron-deploy.s3.us-east-2.amazonaws.com/${pname}_${version}_amd64.deb";
    sha256 = "sha256-veDWBFZbODsdaO1UdfuC4w6oGCkeVBe+fqKn5XVHKDQ=";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"

    ln -s "$out/opt/Roam Research/roam-research" "$out/bin/roam-research"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/Roam Research:\$ORIGIN" "$out/opt/Roam Research/roam-research"

    mv usr/* "$out/"

    substituteInPlace $out/share/applications/roam-research.desktop \
      --replace "/opt/Roam Research/roam-research" "roam-research"
  '';

  dontPatchELF = true;
  meta = with lib; {
    description = "A note-taking tool for networked thought.";
    homepage = "https://roamresearch.com/";
    maintainers = with lib.maintainers; [ dbalan ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
