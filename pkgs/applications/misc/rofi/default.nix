{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libxkbcommon
, pango
, which
, git
, cairo
, libxcb
, xcbutil
, xcbutilwm
, xcbutilxrm
, xcb-util-cursor
, libstartup_notification
, bison
, flex
, librsvg
, check
, waylandSupport ? false
, wayland-protocols
, wayland
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  owner = if waylandSupport then "lbonn" else "davatorium";
  version = "1.7.1" + lib.optionalString waylandSupport "+wayland1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    sha256 =
      if waylandSupport
      then "8CLBBRvtz9nYAHJLdBUX99sH3ZC+242wUtE7tXm5B7o="
      else "Qn6IYRSZYW16a8i1JizrMsGhJZNQkpCzwWMOcHfttAA=";
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    libxkbcommon
    pango
    cairo
    git
    bison
    flex
    librsvg
    check
    libstartup_notification
    libxcb
    xcbutil
    xcbutilwm
    xcbutilxrm
    xcb-util-cursor
    which
  ] ++ lib.optionals waylandSupport [
    wayland-protocols
    wayland
  ];

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/${owner}/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ bew ];
    platforms = with platforms; linux;
  };
}
