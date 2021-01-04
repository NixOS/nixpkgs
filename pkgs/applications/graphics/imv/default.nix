{ asciidoc
, cmocka
, docbook_xsl
, fetchFromGitHub
, fontconfig
, freeimage
, icu
, libGLU
, libheif
, libjpeg_turbo
, libpng
, librsvg
, libtiff
, libxkbcommon
, libxslt
, netsurf
, pango
, pkgconfig
, stdenv
, wayland
, meson
, ninja
, inih
}:

stdenv.mkDerivation rec {
  pname = "imv";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "eXeC64";
    repo = "imv";
    rev = "v${version}";
    sha256 = "07pcpppmfvvj0czfvp1cyq03ha0jdj4whl13lzvw37q3vpxs5qqh";
  };

  nativeBuildInputs = [
    asciidoc
    cmocka
    docbook_xsl
    libxslt
    meson
    ninja
  ];

  buildInputs = [
    freeimage
    icu
    libGLU
    libjpeg_turbo
    librsvg
    libxkbcommon
    netsurf.libnsgif
    pango
    pkgconfig
    wayland
    inih
    libtiff
    libheif
    libpng
  ];

  postFixup = ''
    # The `bin/imv` script assumes imv-wayland or imv-x11 in PATH,
    # so we have to fix those to the binaries we installed into the /nix/store

    substituteInPlace "$out/bin/imv" \
      --replace "imv-wayland" "$out/bin/imv-wayland" \
      --replace "imv-x11" "$out/bin/imv-x11"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A command line image viewer for tiling window managers";
    homepage = "https://github.com/eXeC64/imv";
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj markus1189 ];
    platforms = platforms.all;
  };
}
