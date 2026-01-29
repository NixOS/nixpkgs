{
  lib,
  fetchFromGitLab,
  stdenv,
  luaPackages,
}:

stdenv.mkDerivation rec {
  pname = "deps.fnl";
  version = "0.2.5";

  src = fetchFromGitLab {
    owner = "andreyorst";
    repo = "deps.fnl";
    rev = version;
    hash = "sha256-gUqi0g7myWTbjILN4RQqbeeaSYcg0oVJYNO0Gv9XzNY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    # deps requires argv0 to be fennel as an executable lua script
    # skipping the luarocks wrapper is fine here
    substitute deps $out/bin/deps \
      --replace-fail '#!/usr/bin/env fennel' '#!${luaPackages.fennel}/fennel*/fennel/*/bin/fennel'
    chmod +x $out/bin/deps

    runHook postInstall
  '';

  meta = {
    description = "A dependency and a PATH manager for Fennel";
    homepage = "https://gitlab.com/andreyorst/deps.fnl";
    license = lib.licenses.mit;
    mainProgram = "deps";
    maintainers = with lib.maintainers; [ emily-lavender ];
    platforms = lib.platforms.all;
  };
}
