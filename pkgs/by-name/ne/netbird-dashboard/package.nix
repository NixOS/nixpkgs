{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.32.5";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-DNIibCGeC4dzJ8xKQPLkWJZ2YfW2igLse+321SrSmhE=";
  };

  npmDepsHash = "sha256-shN+XdS5Z2MxEFy453YqqovDUXbde3L9Y7+cPZW53/Y=";
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
