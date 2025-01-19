{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-netq6VCZcGBj5jv+pekRTxd6s0Lr45yuqZThs0qoc64=";
  };

  npmDepsHash = "sha256-MbVBeZWX9e4eLz2ZRG0qYr9oTkBGhFPJ5m/rVEfGLuc=";
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
    maintainers = with lib.maintainers; [ vrifox ];
  };
}
