{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, libxcb, xcbutilkeysyms, xcbutilimage,
  xcbutilxrm, pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  pname = "i3lock";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "i3";
    repo = "i3lock";
    rev = version;
    sha256 = "sha256-cC908c47fkU6msLqZSxpEbKxO1/PatH81QeuCzBSZGw=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libxcb xcbutilkeysyms xcbutilimage xcbutilxrm
    pam libX11 libev cairo libxkbcommon libxkbfile ];

  meta = with lib; {
    description = "A simple screen locker like slock";
    longDescription = ''
      Simple screen locker. After locking, a colored background (default: white) or
      a configurable image is shown, and a ring-shaped unlock-indicator gives feedback
      for every keystroke. After entering your password, the screen is unlocked again.
    '';
    homepage = "https://i3wm.org/i3lock/";
    maintainers = with maintainers; [ malyn domenkozar ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };

}
