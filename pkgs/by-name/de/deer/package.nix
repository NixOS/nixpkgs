{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "deer";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Vifon";
    repo = "deer";
    rev = "v${version}";
    sha256 = "1xnbnbi0zk2xsyn8dqsmyxqlfnl36pb1wwibnlp0dxixw6sfymyl";
  };

  strictDeps = true;

  prePatch = ''
    substituteInPlace deer \
      --replace " perl " " ${perl}/bin/perl "
  '';

  patches = [ ./realpath.patch ];

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions/
    cp deer $out/share/zsh/site-functions/
  '';

<<<<<<< HEAD
  meta = {
    description = "Ranger-like file navigation for zsh";
    homepage = "https://github.com/Vifon/deer";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Ranger-like file navigation for zsh";
    homepage = "https://github.com/Vifon/deer";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
