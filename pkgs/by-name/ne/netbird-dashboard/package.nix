{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.91.1";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-TA+H1v4Xd56UcJtNLZrTOPjvOuwBmkmX2UpbLsBJA+A=";
  };

  npmDepsHash = "sha256-KWEVpESs71ng9uGbgP1xHihFhRONDE81wx6y3O4BoAY=";
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
