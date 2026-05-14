{
  lib,
  stdenv,
  fetchFromGitHub,
  guile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fetch-scm";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "KikyTokamuro";
    repo = "fetch.scm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WdYi8EVxQ6xPtld8JyZlUmgpxroevBehtkRANovMh2E=";
  };

  dontBuild = true;

  buildInputs = [ guile ];

  installPhase = ''
    runHook preInstall
    install -Dm555 fetch.scm $out/bin/fetch-scm
    runHook postInstall
  '';

  meta = {
    description = "System information fetcher written in GNU Guile Scheme";
    homepage = "https://github.com/KikyTokamuro/fetch.scm";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ vel ];
    mainProgram = "fetch-scm";
  };
})
