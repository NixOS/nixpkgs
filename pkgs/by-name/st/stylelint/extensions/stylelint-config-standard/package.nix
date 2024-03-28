{ lib, buildNpmPackage, fetchFromGitHub }:
buildNpmPackage rec {
  pname = "stylelint-config-standard";
  version = "36.0.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = pname;
    rev = version;
    hash = "sha256-5uW11/LXfjII1IKTYazcdL/GqxCvJpp6Jq7cOFn45JI=";
  };

  dontNpmBuild = true;
  npmDepsHash = "sha256-jLDLDSG0HjKmSj5cTee4LF1aJnqJqpKX+WI9J1/6vHo=";
  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    homepage = "https://github.com/stylelint/stylelint-config-standard";
    description = "The standard shareable config for Stylelint";
    license = licenses.mit;
    maintainers = with maintainers; [ eownerdead ];
    platforms = platforms.all;
  };
}

