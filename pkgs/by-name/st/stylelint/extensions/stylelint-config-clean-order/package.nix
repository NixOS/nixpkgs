{ lib, buildNpmPackage, fetchFromGitHub }:
buildNpmPackage rec {
  pname = "stylelint-config-clean-order";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "kutsan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I8fBJFSS74FyA77IYWfTWlgEVwLMsHekmMOCaJcbH4E=";
  };

  dontNpmBuild = true;
  npmDepsHash = "sha256-b3lxKp+mK3wZUrks3nzcNjW/MNZTS3VH+eyJYsEK2hc=";
  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    homepage = "https://github.com/kutsan/stylelint-config-clean-order";
    description = "A clean and complete config for stylelint-order";
    license = licenses.mit;
    maintainers = with maintainers; [ eownerdead ];
    platforms = platforms.all;
  };
}

