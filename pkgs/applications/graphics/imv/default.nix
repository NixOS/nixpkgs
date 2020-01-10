{ stdenv, fetchFromGitHub
, freeimage, fontconfig, pkgconfig
, asciidoc, docbook_xsl, libxslt, cmocka
, librsvg, pango, libxkbcommon, wayland
, libGLU, icu
}:

stdenv.mkDerivation rec {
  pname = "imv";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner  = "eXeC64";
    repo   = "imv";
    rev    = "v${version}";
    sha256 = "sha256:0gk8g178i961nn3bls75a8qpv6wvfvav6hd9lxca1skaikd33zdx";
  };

  preBuild = ''
    # Version is 4.0.1, but Makefile was not updated
    sed -i 's/echo v4\.0\.0/echo v4.0.1/' Makefile
  '';

  nativeBuildInputs = [
    asciidoc
    cmocka
    docbook_xsl
    libxslt
  ];

  buildInputs = [
    freeimage
    libGLU
    librsvg
    libxkbcommon
    pango
    pkgconfig
    wayland
    icu
  ];

  installFlags = [ "PREFIX=$(out)" "CONFIGPREFIX=$(out)/etc" ];

  postFixup = ''
    # The `bin/imv` script assumes imv-wayland or imv-x11 in PATH,
    # so we have to fix those to the binaries we installed into the /nix/store

    sed -i "s|\bimv-wayland\b|$out/bin/imv-wayland|" $out/bin/imv
    sed -i "s|\bimv-x11\b|$out/bin/imv-x11|" $out/bin/imv
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage    = https://github.com/eXeC64/imv;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj markus1189 ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
