{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "qlever-ui-frontend";
  version = "0-unstable-2026-04-26";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlever-ui";
    rev = "ae139a1cd5ebd704e0eb273c8ca57b8a689184e7";
    hash = "sha256-DIlmSaRdOJXDj3HvAxnSzmEr6595x9Avcg0jWH9fUuU=";
  };

  npmDepsHash = "sha256-Zq7+HLPO+lVYJflz7SK1rTgQtNSgbx2mZ7wFd6McBCo=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ./backend/static/wasm/* $out/
    runHook postInstall
  '';

  meta = {
    description = "Frontend for QLever UI";
    homepage = "https://github.com/qlever-dev/qlever-ui";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
  };
})
