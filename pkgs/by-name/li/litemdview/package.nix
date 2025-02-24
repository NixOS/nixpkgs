{
  lib,
  stdenv,
  fetchFromGitea,
  gtkmm3,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "litemdview";
  # litemdview -v
  version = "0.0.32";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "g0tsu";
    repo = "litemdview";
    rev = "litemdview-0.0.32";
    hash = "sha256-XGjP+7i3mYCEzPYwVY+75DARdXJFY4vUWHFpPeoNqAE=";
  };

  buildInputs = [
    gtkmm3
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://notabug.org/g0tsu/litemdview";
    description = "Suckless markdown viewer";
    longDescription = ''
      LiteMDview is a lightweight, extremely fast markdown viewer with lots of useful features. One of them is ability to use your prefered text editor to edit markdown files, every time you save the file, litemdview reloads those changes (I call it live-reload). It has a convinient navigation through local directories, has support for a basic "git-like" folders hierarchy as well as vimwiki projects.

      Features:


        - Does not use any of those bloated gecko(servo)-blink engines
        - Lightweight and fast
        - Live reload
        - Convinient key bindings
        - Supports text zooming
        - Supports images
        - Supports links
        - Navigation history
        - Cool name which associates with 1337, at least for me :)
        - Builtin markdown css themes
        - Supports emoji™️
        - vimwiki support
        - Basic html support (very simple offline documents in html)
        - Syntax highlighting
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ WhiteBlackGoose ];
    platforms = platforms.linux;
    mainProgram = "litemdview";
  };
}
