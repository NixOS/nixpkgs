{ fetchurl, lib, stdenv, which, pkg-config, libxcb, xcbutilkeysyms, xcbutilimage,
  xcbutilxrm, pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  pname = "i3lock";
  version = "2.13";

  src = fetchurl {
    url = "https://i3wm.org/i3lock/${pname}-${version}.tar.bz2";
    sha256 = "02szjsaz7rqrdkd0r2nwgwa85c4hwfrcskxw7ryk695kmjcfhzv3";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ which libxcb xcbutilkeysyms xcbutilimage xcbutilxrm
    pam libX11 libev cairo libxkbcommon libxkbfile ];

  makeFlags = [ "all" ];
  installFlags = [ "PREFIX=\${out}" "SYSCONFDIR=\${out}/etc" ];
  postInstall = ''
    mkdir -p $out/share/man/man1
    cp *.1 $out/share/man/man1
  '';

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
