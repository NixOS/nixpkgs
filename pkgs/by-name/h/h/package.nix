{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  ruby,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "h";
  version = "1.1.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iv+BqM6AF7wD5yyFSvA5pkG2yfQrNp6aBFV1OCUom5c=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ruby ];

  installPhase = ''
    runHook preInstall

    installBin h
    installBin up

    runHook postInstall
  '';

  meta = {
    description = "Faster shell navigation of projects";
    homepage = "https://github.com/zimbatm/h";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
    mainProgram = "h";
  };
})
