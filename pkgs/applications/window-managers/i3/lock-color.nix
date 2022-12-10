{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libxcb,
  xcbutilkeysyms , xcbutilimage, pam, libX11, libev, cairo, libxkbcommon,
  libxkbfile, libjpeg_turbo, xcbutilxrm
}:

stdenv.mkDerivation rec {
  version = "2.13.c.4";
  pname = "i3lock-color";

  src = fetchFromGitHub {
    owner = "PandorasFox";
    repo = "i3lock-color";
    rev = version;
    sha256 = "sha256-bbjkvgSKD57sdOtPYGLAKpQoIsJnF6s6ySq4dTWC3tI=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile libjpeg_turbo xcbutilxrm ];

  makeFlags = [ "all" ];
  preInstall = ''
    mkdir -p $out/share/man/man1
  '';
  installFlags = [ "PREFIX=\${out}" "SYSCONFDIR=\${out}/etc" "MANDIR=\${out}/share/man" ];
  postInstall = ''
    mv $out/bin/i3lock $out/bin/i3lock-color
    mv $out/share/man/man1/i3lock.1 $out/share/man/man1/i3lock-color.1
    sed -i 's/\(^\|\s\|"\)i3lock\(\s\|$\)/\1i3lock-color\2/g' $out/share/man/man1/i3lock-color.1
  '';
  meta = with lib; {
    description = "A simple screen locker like slock, enhanced version with extra configuration options";
    longDescription = ''
      Simple screen locker. After locking, a colored background (default: white) or
      a configurable image is shown, and a ring-shaped unlock-indicator gives feedback
      for every keystroke. After entering your password, the screen is unlocked again.

      i3lock-color is forked from i3lock (https://i3wm.org/i3lock/) with the following
      enhancements / additional configuration options:

      - indicator:
        - shape: ring or bar
        - size: configurable
        - all colors: configurable
        - all texts: configurable
        - visibility: can be always visible, can be restricted to some screens

      - background: optionally show a blurred screen instead of a single color

      - more information: show text at configurable positions:
        - clock: time/date with configurable format
        - keyboard-layout
    '';
    homepage = "https://github.com/PandorasFox/i3lock-color";
    maintainers = with maintainers; [ malyn ];
    license = licenses.bsd3;

    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
