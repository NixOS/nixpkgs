{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.80.0";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-Z0yE6w7CIBE/JD/JS4ehz+lT2lKoK8U9mjifMaO/joM=";
  };

  npmDepsHash = "sha256-weTRhkPGoNF34iHOITCBhZj9LWwWmemMOng51aAv+BU=";
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
