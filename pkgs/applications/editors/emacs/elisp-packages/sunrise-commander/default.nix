{ lib
, stdenv
, fetchFromGitHub
, emacs
}:

stdenv.mkDerivation rec {
  pname = "sunrise-commander";
  version = "0.0.0+unstable=2021-07-22";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "7662f635c372224e2356d745185db1e718fb7ee4";
    hash = "sha256-NYUqJ2rDidVchX2B0+ApNbQeZFxxCnKRYXb6Ia+NzLI=";
  };

  buildInputs = [
    emacs
  ];

  buildPhase = ''
    runHook preBuild
    emacs -q --no-splash --directory=. --batch --file=batch-byte-compile *.el
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/sunrise-commander/sunrise-commander/";
    description = "Orthodox (two-pane) file manager for Emacs";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.all;
  };
}
