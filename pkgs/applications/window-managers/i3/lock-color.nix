{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libxcb,
  xcbutilkeysyms , xcbutilimage, pam, libX11, libev, cairo, libxkbcommon,
  libxkbfile, libjpeg_turbo
}:

stdenv.mkDerivation rec {
  version = "2.10.1-1-c";
  name = "i3lock-color-${version}";

  src = fetchFromGitHub {
    owner = "PandorasFox";
    repo = "i3lock-color";
    rev = "01476c56333cccae80cdd3f125b0b9f3a0fe2cb3";
    sha256 = "06ca8496fkdkvh4ycg0b7kd3r1bjdqdwfimb51v4nj1lm87pdkdf";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile libjpeg_turbo ];

  makeFlags = "all";
  preInstall = ''
    mkdir -p $out/share/man/man1
  '';
  installFlags = "PREFIX=\${out} SYSCONFDIR=\${out}/etc MANDIR=\${out}/share/man";
  postInstall = ''
    mv $out/bin/i3lock $out/bin/i3lock-color
  '';
  meta = with stdenv.lib; {
    description = "A simple screen locker like slock";
    homepage = https://i3wm.org/i3lock/;
    maintainers = with maintainers; [ garbas malyn ];
    license = licenses.bsd3;

    # Needs the SSE2 instruction set. See upstream issue
    # https://github.com/chrjguill/i3lock-color/issues/44
    platforms = platforms.x86;
  };
}
