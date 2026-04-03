{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.36.0";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-VsecD83dz6U6jEaGIxv7M9ePzbTPCXeffSoyyBr2Vh4=";
  };

  npmDepsHash = "sha256-ljko66NYBgwyvgIbqnexfbSaILNf/74qrNXZUsHT8/o=";
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
