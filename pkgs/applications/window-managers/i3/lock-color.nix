{ stdenv, fetchFromGitHub, which, pkgconfig, libxcb, xcbutilkeysyms
, xcbutilimage, pam, libX11, libev, cairo, libxkbcommon, libxkbfile }:

stdenv.mkDerivation rec {
  version = "2.9.1-c";
  name = "i3lock-color-${version}";

  src = fetchFromGitHub {
    owner = "chrjguill";
    repo = "i3lock-color";
    rev = version;
    sha256 = "0qnw71qbppgp3ywj1k07av7wkl9syfb8j6izrkhj143q2ks4rkvl";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which libxcb xcbutilkeysyms xcbutilimage pam libX11
    libev cairo libxkbcommon libxkbfile ];

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
    platforms = platforms.i686 ++ platforms.x86_64;
  };
}
