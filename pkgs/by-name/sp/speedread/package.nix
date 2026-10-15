{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "speedread";
  version = "unstable-2016-09-21";

  src = fetchFromGitHub {
    owner = "pasky";
    repo = "speedread";
    rev = "93acfd61a1bf4482537ce5d71b9164b8446cb6bd";
    hash = "sha256-rc/2OlB7HQojLdMUhhb20g3TyxOyOkoMo82hsEeXJME=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    install -m755 -D speedread $out/bin/speedread
  '';

  meta = {
    description = "Simple terminal-based open source Spritz-alike";
    longDescription = ''
      Speedread is a command line filter that shows input text as a
      per-word rapid serial visual presentation aligned on optimal
      reading points. This allows reading text at a much more rapid
      pace than usual as the eye can stay fixed on a single place.
    '';
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.oxij ];
    mainProgram = "speedread";
  };
})
