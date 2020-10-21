{ stdenv
, lib
, fetchurl
, dpkg
, gtk3
, atk
, at-spi2-atk
, at-spi2-core
, glib
, pango
, gdk-pixbuf
, cairo
, freetype
, fontconfig
, dbus
, libXi
, libXcursor
, libXdamage
, libXrandr
, libXcomposite
, libXext
, libXfixes
, libXrender
, libX11
, libXtst
, libXScrnSaver
, libxcb
, makeWrapper
, nodejs
, nss
, nspr
, alsaLib
, cups
, expat
, systemd
, libpulseaudio
}:
let
  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc
    gtk3
    atk
    at-spi2-atk
    at-spi2-core
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
    alsaLib
    cups
    expat
    systemd
    libpulseaudio
  ];
in
stdenv.mkDerivation rec {

  version = "1.0.106";
  pname = "terminus";
  src = fetchurl {
    url = "https://github.com/Eugeny/terminus/releases/download/v${version}/terminus-${version}-linux.deb";
    sha256 = "1kfkw6is2y4fmv115msd9sfn8qfyf3prxx59zlq7411ddz5xmfzg";
  };
  buildInputs = [ dpkg makeWrapper ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"
    ln -s "$out/opt/Terminus/terminus" "$out/bin/terminus"

    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        "$out/opt/Terminus/terminus"

    wrapProgram $out/bin/terminus \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${libPath}
    mv usr/* "$out/"
  '';
  dontPatchELF = true;
  meta = with lib; {
    description = "A terminal for a more modern age";
    homepage = "https://eugeny.github.io/terminus/";
    maintainers = with maintainers; [];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
