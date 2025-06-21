{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-D/EnyOSADy/9IgddDeWxCYBHAaAqUrEkrYESig786t0=";
  };

  npmDepsHash = "sha256-5a2OXxTjamRpm1PBrJWYtrvAT1c9qfAOja7gpkt2stI=";
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    cp -R out $out
  '';

  env = {
    CYPRESS_INSTALL_BINARY = 0;
  };

  meta = with lib; {
    description = "NetBird Management Service Web UI Panel";
    homepage = "https://github.com/netbirdio/dashboard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
