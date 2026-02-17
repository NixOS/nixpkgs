{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-vpxMPoF0xn5UzY1Yo5Y2NAfmwC21Z6Ogv+C30JKyj0E=";
  };

  npmDepsHash = "sha256-IyNVeoEusQlxOYzYe9xIwtHepDRyjUfKHGNNR8LoOSA=";
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
