{ dbus
, docbook_xml_dtd_45
, docbook_xsl
, fetchFromGitHub
, lib
, libconfig
, libdrm
, libev
, libGL
, libX11
, libxcb
, libxdg_basedir
, libXext
, libXinerama
, libxml2
, libxslt
, makeWrapper
, meson
, ninja
, pcre2
, pixman
, pkg-config
, stdenv
, uthash
, xcbutilimage
, xcbutilrenderutil
, xorgproto
, xwininfo
, withDebug ? false
}:

stdenv.mkDerivation rec {
  pname = "compfy";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "compfy";
    rev = "1.7.0";
    hash = "sha256-tuM+nT2dp3L5QIMZcO/W6tmDLSDt1IQposzrS5NzYpw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
    meson
    ninja
    pkg-config
    uthash
  ];

  buildInputs = [
    dbus
    libconfig
    libdrm
    libev
    libGL
    libX11
    libxcb
    libxdg_basedir
    libXext
    libXinerama
    libxml2
    libxslt
    pcre2
    pixman
    xcbutilimage
    xcbutilrenderutil
    xorgproto
  ];

  mesonBuildType = if withDebug then "debugoptimized" else "release";
  dontStrip = withDebug;

  mesonFlags = [
    "-Dwith_docs=true"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = '''';

  meta = with lib; {
    description = "A Linux Compositor for X11. Based on Picom. Providing Animations and More";
    license = with lib.licenses; [ mit mpl20 ];
    homepage = "https://github.com/allusive-dev/compfy";
    maintainers = with maintainers; [ allusive iogamaster ];
    platforms = platforms.linux;
    mainProgram = "compfy";
  };
}
