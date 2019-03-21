{ stdenv, fetchFromGitHub, pkgconfig, xorgproto, libxcb, xcbutilkeysyms
, xorg , i3ipc-glib , glib
}:

stdenv.mkDerivation rec {
  name = "i3easyfocus-${version}";
  version = "20180622";

  src = fetchFromGitHub {
    owner = "cornerman";
    repo = "i3-easyfocus";
    rev = "3631d5af612d58c3d027f59c86b185590bd78ae1";
    sha256 = "1wgknmmm7iz0wxsdh29gmx4arizva9101pzhnmac30bmixf3nzhr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxcb xcbutilkeysyms xorgproto xorg.libX11.dev i3ipc-glib glib.dev ];

  # Makefile has no rule for 'install'
  installPhase = ''
    mkdir -p $out/bin
    cp i3-easyfocus $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Focus and select windows in i3";
    homepage = https://github.com/cornerman/i3-easyfocus;
    maintainers = with maintainers; [teto];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
