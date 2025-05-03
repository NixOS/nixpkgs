{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-JHpFxWhN5ZXd0Yn0AY98pl/nrby+RsWO6l8qUospkak=";
  };

  npmDepsHash = "sha256-TELyc62l/8IaX9eL2lxRFth0AAZ4LXsV2WNzXSHRnTw=";
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
    maintainers = with maintainers; [
      vrifox
      patrickdag
    ];
  };
}
