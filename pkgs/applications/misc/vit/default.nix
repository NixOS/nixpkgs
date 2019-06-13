{ stdenv, fetchFromGitHub
, makeWrapper, which
, taskwarrior, ncurses, perlPackages }:

stdenv.mkDerivation rec {
  pname = "vit";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a34rh5w8393wf7jwwr0f74rp1zv2vz606z5j8sr7w19k352ijip";
  };

  preConfigure = ''
    substituteInPlace Makefile.in \
      --replace sudo ""
    substituteInPlace configure \
      --replace /usr/bin/perl ${perlPackages.perl}/bin/perl
    substituteInPlace cmdline.pl \
      --replace "view " "vim -R "
  '';

  postInstall = ''
    wrapProgram $out/bin/vit --prefix PERL5LIB : $PERL5LIB
  '';

  nativeBuildInputs = [ makeWrapper which ];
  buildInputs = [ taskwarrior ncurses ]
    ++ (with perlPackages; [ perl Curses TryTiny TextCharWidth ]);

  meta = with stdenv.lib; {
    description = "Visual Interactive Taskwarrior";
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}

