{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "1.17.15";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-C0vWeyjVWiTUXkumXDZsfadZW8O9DtIarnN7djuDtQI=";
  };

  npmDepsHash = "sha256-x7YyzBPAiXyxaIcAvUrXBexYaw0TaYnKgQKT3KadW8w=";
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    cp -R build $out
  '';

  meta = with lib; {
    description = "NetBird Management Service Web UI Panel";
    homepage = "https://github.com/netbirdio/dashboard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
  };
}
