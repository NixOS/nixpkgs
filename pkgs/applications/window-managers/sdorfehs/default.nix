{ lib
, stdenv
, fetchgit
, pkg-config
, autoconf
, makeWrapper
, xorg
, libX11
, xorgproto
, libXft
, libXtst
, libXi
, libXres
, libXrandr
}:

stdenv.mkDerivation rec {
  pname = "sdorfehs";
  version = "1.5";

  src = fetchgit {
    name = "sdorfehs";
    url = "https://github.com/jcs/${pname}";
    rev = "v${version}";
    sha256 = "sha256-FVEriT8WojUKrdBuxbr7rNIkFpfrkRtmuBw5Gscz2qM=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    makeWrapper
  ];

  buildInputs = [
    libX11
    libXtst
    libXi
    libXres
    libXft
    libXrandr
  ];

  strictDeps = true;

  installFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    homepage = "https://github.com/jcs/sdorfehs";
    description = "A tiling window manager descended from ratpoison";
    license = licenses.gpl2Plus;

    longDescription = ''
      (pronounced "starfish")
      sdorfehs is a tiling window manager descended from ratpoison (which itself is modeled after GNU Screen).
      sdorfehs divides the screen into one or more frames, each only displaying one window at a time but can cycle through all available windows (those which are not being shown in another frame).
      Like Screen, sdorfehs primarily uses prefixed/modal key bindings for most actions. sdorfehs's command mode is entered with a configurable keystroke (Control+a by default) which then allows a number of bindings accessible with just a single keystroke or any other combination. For example, to cycle through available windows in a frame, press Control+a then n.
    '';

    platforms = platforms.unix;
    maintainers = [ maintainers.shassard ];
  };
}
