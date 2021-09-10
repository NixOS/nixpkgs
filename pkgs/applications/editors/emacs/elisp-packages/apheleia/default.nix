{ lib
, stdenv
, fetchFromGitHub
, emacs
}:

stdenv.mkDerivation rec {
  pname = "apheleia";
  version = "0.0.0+unstable=2021-08-08";

  src = fetchFromGitHub {
    owner = "raxod502";
    repo = pname;
    rev = "8e022c67fea4248f831c678b31c19646cbcbbf6f";
    hash = "sha256-Put/BBQ7V423C18UIVfaM17T+TDWtAxRZi7WI8doPJw=";
  };

  buildInputs = [
    emacs
  ];

  buildPhase = ''
    runHook preBuild
    emacs -L . --batch -f batch-byte-compile *.el
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/raxod502/apheleia";
    description = "Asynchronous buffer reformat";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres leungbk ];
    platforms = emacs.meta.platforms;
  };
}
