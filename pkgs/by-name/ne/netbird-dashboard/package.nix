{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "2.19.2";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-3rHNk/rc0j5mWF2jbrMOtFrDkosph1YWnFoh1lLHTPs=";
  };

  npmDepsHash = "sha256-pC4Vvkb+NAGyhd090LAeGZTLVGufnC9LylJGQt8aEZg=";
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
      patrickdag
    ];
  };
}
