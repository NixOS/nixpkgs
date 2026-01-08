{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.26.1";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-8MC3sHKs7HmxzqFw7px+Q0zX9PzzZhb4I5gcJ/fQ4uc=";
  };

  npmDepsHash = "sha256-RIhVSRjqzFawXaRZHAUwGodnNerGz+I3GbPFsP5qESY=";
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    cp -R out $out
  '';

  env = {
    CYPRESS_INSTALL_BINARY = 0;
  };

  meta = {
    description = "NetBird Management Service Web UI Panel";
    homepage = "https://github.com/netbirdio/dashboard";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      patrickdag
    ];
  };
}
