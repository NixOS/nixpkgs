{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.90.3";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-S/bXB2O5Y+WWDNRtsPrzTSDd5TGpGDxCBCVf3akV8So=";
  };

  npmDepsHash = "sha256-A6zXrOPdxLepi7XPn67YsY673iFOAgJqCEynn4SYco8=";
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    cp -R out $out
  '';

  env = {
    CYPRESS_INSTALL_BINARY = 0;
    NEXT_PUBLIC_DASHBOARD_VERSION = version;
  };

  meta = {
    description = "NetBird Management Service Web UI Panel";
    homepage = "https://github.com/netbirdio/dashboard";
    license = lib.licenses.bsd3;
    maintainers = [
    ];
  };
}
