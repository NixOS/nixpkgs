{ lib
, stdenv
, fetchFromBitbucket
, xcbutil
, xcbutilkeysyms
, xcbutilwm
, xcb-util-cursor
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dk";
  version = "1.9";

  src = fetchFromBitbucket {
    owner = "natemaia";
    repo = "dk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OodD2z9C4oGTK6ynAXRlEZSzzdzIkVjmq5vLdUcht1U=";
  };

  buildInputs = [
    xcbutil
    xcbutilkeysyms
    xcbutilwm
    xcb-util-cursor
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-L/usr/X11R6/lib" "" \
      --replace "-I/usr/X11R6/include" ""
  '';

  makeFlags = [ "PREFIX=$(out)" "SES=$(out)/share/xsessions" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://bitbucket.org/natemaia/dk";
    description = "A list based tiling window manager in the vein of dwm, bspwm, and xmonad";
    license = lib.licenses.x11;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    platforms = lib.platforms.linux;
  };
})
