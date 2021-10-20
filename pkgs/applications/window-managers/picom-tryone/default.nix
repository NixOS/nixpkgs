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
  pname = "picom-tryone";
  version = "8.2";

  src = fetchFromGitHub {
    owner = "tryone144";
    repo = "picom";
    rev = "5e0215abab83f11628703bfd279d618bca4ce5ef";
    sha256 = "1ajv396p5421clwzm3am08gcp9nqqrwp2v92g6n0vwxqnx7c2di8";
    fetchSubmodules = false;
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
      well-defined and proper place. This tryone fork contains patches for
      dual_kawase blur support
      The package can be installed in debug mode as:
        picom.override { withDebug = true; }
      For gdb to find the source files, you need to run gdb in the bin directory
      of picom package in the nix store.
    '';
    license = licenses.mit;
    homepage = "https://github.com/yshui/picom";
    maintainers = with maintainers; [ GKasparov ];
    platforms = platforms.linux;
  };
}
