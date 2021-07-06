{ stdenv, fetchFromGitHub, emacs, lib }:

stdenv.mkDerivation {
  pname = "youtube-dl";
  version = "2018-10-12";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "youtube-dl-emacs";
    rev = "af877b5bc4f01c04fccfa7d47a2c328926f20ef4";
    sha256 = "sha256-Etl95rcoRACDPjcTPQqYK2L+w8OZbOrTrRT0JadMdH4=";
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
    description = "Emacs frontend to the youtube-dl utility";
    homepage = "https://github.com/skeeto/youtube-dl-emacs";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = emacs.meta.platforms;
  };
}
