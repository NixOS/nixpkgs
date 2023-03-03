{ asciidoc
, dbus
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
, pcre
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
  pname = "picom";
  version = "10.2";

  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "v${version}";
    hash = "sha256-C+icJXTkE+XMaU7N6JupsP8xhmRVggX9hY1P7za0pO0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    asciidoc
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
    pcre
    pixman
    xcbutilimage
    xcbutilrenderutil
    xorgproto
  ];

  # Use "debugoptimized" instead of "debug" so perhaps picom works better in
  # normal usage too, not just temporary debugging.
  mesonBuildType = if withDebug then "debugoptimized" else "release";
  dontStrip = withDebug;

  mesonFlags = [
    "-Dwith_docs=true"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  # In debug mode, also copy src directory to store. If you then run `gdb picom`
  # in the bin directory of picom store path, gdb finds the source files.
  postInstall = ''
    wrapProgram $out/bin/picom-trans \
      --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
  '' + lib.optionalString withDebug ''
    cp -r ../src $out/
  '';

  meta = with lib; {
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.

      The package can be installed in debug mode as:

        picom.override { withDebug = true; }

      For gdb to find the source files, you need to run gdb in the bin directory
      of picom package in the nix store.
    '';
    license = licenses.mit;
    homepage = "https://github.com/yshui/picom";
    maintainers = with maintainers; [ ertes twey thiagokokada ];
    platforms = platforms.linux;
  };
}
