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
    tag = version;
    hash = "sha256-gUqi0g7myWTbjILN4RQqbeeaSYcg0oVJYNO0Gv9XzNY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    # deps requires argv0 to be fennel as an executable lua script
    # skipping the luarocks wrapper is fine here
    fennelLua=$(echo ${luaPackages.fennel}/fennel*/fennel/*/bin/fennel)
    substitute deps $out/bin/deps \
      --replace-fail '#!/usr/bin/env fennel' "#!$fennelLua"
    chmod +x $out/bin/deps

    runHook postInstall
  '';

  meta = {
    description = "Dependency and PATH manager for Fennel";
    homepage = "https://gitlab.com/andreyorst/deps.fnl";
    license = lib.licenses.mit;
    mainProgram = "deps";
    maintainers = with lib.maintainers; [ emily-lavender ];
    platforms = lib.platforms.all;
  };
}
