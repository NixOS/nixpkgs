{ lib
, pkgs
, writeShellScriptBin
, makeWrapper
, buildNpmPackage
, fetchFromGitHub
}:
let
  env = f:
    writeShellScriptBin "stylelint" ''
      export NODE_PATH="$NODE_PATH:${
        lib.makeSearchPath "lib/node_modules"
        ([ stylelint ] ++ (f stylelint.extensions))
      }"

      exec ${stylelint}/bin/stylelint "$@"
    '';

  stylelint = buildNpmPackage rec {
    pname = "stylelint";
    version = "16.2.0";

    src = fetchFromGitHub {
      owner = "stylelint";
      repo = pname;
      rev = version;
      hash = "sha256-l7+Pd+H/JOKK/sIt0FwDU69t/dWUNhI+JnkBk9MSTtg=";
    };

    npmDepsHash = "sha256-F4XSp6s4VHZdHAeGfY/XHK6+PSpNi3ZMzFKRK6eQ+Uw=";

    meta = with lib; {
      homepage = "https://stylelint.io/";
      description =
        "A mighty CSS linter that helps you avoid errors and enforce conventions";
      license = licenses.mit;
      maintainers = with maintainers; [ eownerdead ];
      mainProgram = "stylelint";
      platforms = platforms.all;
    };

    passthru = {
      extensions = import ./extensions { inherit pkgs; };
      withExtensions = env;
    };
  };
in
stylelint
