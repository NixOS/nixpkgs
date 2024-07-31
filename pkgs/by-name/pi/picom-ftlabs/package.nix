{ asciidoc, dbus, docbook_xml_dtd_45, docbook_xsl, fetchFromGitHub, lib
, libconfig, libdrm, libev, libGL, libepoxy, libX11, libxcb, libxdg_basedir
, libXext, libxml2, libxslt, makeWrapper, meson, ninja, pcre2, pixman
, pkg-config, stdenv, uthash, xcbutil, xcbutilimage, xcbutilrenderutil
, xorgproto, xwininfo, withDebug ? false, }:
stdenv.mkDerivation (finalAttrs: {
  pname = "picom-ftlabs";
  version = "df4c6a3"; # Example date for the version

  src = fetchFromGitHub {
    owner = "FT-labs";
    repo = "picom";
    rev = "${finalAttrs.version}";
    hash = "sha256-FmORxY7SLFnAmtQyC82sK36RoUBa94rJ7BsDXjXUCXk=";
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
    libepoxy
    libX11
    libxcb
    libxdg_basedir
    libXext
    libxml2
    libxslt
    pcre2
    pixman
    xcbutil
    xcbutilimage
    xcbutilrenderutil
    xorgproto
  ];

  # Use "debugoptimized" instead of "debug" so perhaps picom works better in
  # normal usage too, not just temporary debugging.
  mesonBuildType = if withDebug then "debugoptimized" else "release";
  dontStrip = withDebug;

  mesonFlags = [ "-Dwith_docs=true" ];

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
    description = "Fork of picom";
    longDescription = ''
           To launch with all animations as a background process you can use: picom --animations -b

      To only have specific animations, enable them with cli flags (see picom --help) or add them to your picom config.
      Fork of github.com/yshui/picom

    '';
    license = licenses.mit;
    homepage = "https://github.com/FT-labs/picom";
    maintainers = with maintainers; [ eriksundin ];
    platforms = platforms.linux;
    mainProgram = "picom";
  };
})
