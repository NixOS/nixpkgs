{ lib
, stdenv
, fetchFromGitHub
, emacs
}:

stdenv.mkDerivation rec {
  pname = "sunrise-commander";
  version = "0.0.0-unstable=2021-04-23";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "db880fbea03d2db00db1398c91918c3c6f0392e3";
    hash = "sha256-IGHCKYQaGUapaA9vxq0xO58KCpBPOiQpHqrEaHK0usE=";
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
