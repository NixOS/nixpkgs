{ stdenv, fetchFromGitHub, emacs, lib }:

stdenv.mkDerivation {
  pname = "apheleia";
  version = "2021-05-23";

  src = fetchFromGitHub {
    owner = "raxod502";
    repo = "apheleia";
    rev = "f865c165dac606187a66b2b25a57d5099b452120";
    sha256 = "sha256-n37jJsNOGhSjUtQysG3NVIjjayhbOa52iTXBc8SyKXE=";
  };

  buildInputs = [ emacs ];

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

  meta = {
    description = "Reformat buffer stably";
    homepage = "https://github.com/raxod502/apheleia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
