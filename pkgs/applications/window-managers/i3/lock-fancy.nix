{ stdenv, fetchFromGitHub, makeWrapper
, coreutils, scrot, imagemagick, gawk, i3lock-color, getopt, fontconfig
}:

stdenv.mkDerivation rec {
  name = "i3lock-fancy-unstable-${version}";
  version = "2018-08-27";

  src = fetchFromGitHub {
    owner = "meskarune";
    repo = "i3lock-fancy";
    rev = "f2e9bdd1d27e761f0dca75b89329865545351d70";
    sha256 = "14h0364xbv60shypxyp62ldx0v4bc47zhybiaxlpb9db934rxg8b";
  };

  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
    substituteInPlace i3lock-fancy --replace "i3lock -i" "i3lock-color -i"
    substituteInPlace i3lock-fancy --replace "shot=(import -window root)" "shot=(scrot -z)"
    substituteInPlace i3lock-fancy --replace "/usr/share/i3lock-fancy/icons/" "$out/share/i3lock-fancy/icons/"
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm755 i3lock-fancy          -t "$out/bin"
    install -Dm644 icons/*               -t "$out/share/i3lock-fancy/icons"
    install -Dm644 doc/i3lock-fancy.1    -t "$out/share/man/man1"
    install -Dm644 LICENSE               -t "$out/share/licenses/i3lock-fancy"
  '';

  postFixup = ''
    wrapProgram "$out/bin/i3lock-fancy" --prefix PATH : ${stdenv.lib.makeBinPath [coreutils scrot imagemagick gawk i3lock-color getopt fontconfig]}
  '';

  meta = with stdenv.lib; {
    description = "A bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text";
    homepage = https://github.com/meskarune/i3lock-fancy;
    maintainers = with maintainers; [ garbas jqueiroz ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
