{ stdenv, lib, fetchFromGitHub, pkgconfig, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper, meson, ninja
, xorgproto, libxcb ,xcbutilrenderutil, xcbutilimage, pixman, libev
, dbus, libconfig, libdrm, libGL, pcre, libX11, libXcomposite, libXdamage
, libXinerama, libXrandr, libXrender, libXext, xwininfo, libxdg_basedir }:
stdenv.mkDerivation rec {
  pname = "compton";
  version = "6.2";

  COMPTON_VERSION = "v${version}";

  src = fetchFromGitHub {
    owner  = "yshui";
    repo   = "compton";
    rev    = COMPTON_VERSION;
    sha256 = "03fi9q8zw2qrwpkmy1bnavgfh91ci9in5fdi17g4s5s0n2l7yil7";
  };

  nativeBuildInputs = [
    meson ninja
    pkgconfig
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
  ];

  buildInputs = [
    dbus libX11 libXext
    xorgproto
    libXinerama libdrm pcre libxml2 libxslt libconfig libGL
    libxcb xcbutilrenderutil xcbutilimage
    pixman libev
    libxdg_basedir
  ];

  NIX_CFLAGS_COMPILE = [ "-fno-strict-aliasing" ];

  mesonFlags = [
    "-Dbuild_docs=true"
  ];

  preBuild = ''
    git() { echo "v${version}"; }
    export -f git
  '';

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/compton-trans \
      --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
  '';

  meta = with lib; {
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    license = licenses.mit;
    homepage = "https://github.com/yshui/compton";
    maintainers = with maintainers; [ ertes enzime twey ];
    platforms = platforms.linux;
  };
}
