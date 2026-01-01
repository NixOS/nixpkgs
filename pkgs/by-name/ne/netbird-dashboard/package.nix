{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "netbird-dashboard";
<<<<<<< HEAD
  version = "2.25.0";
=======
  version = "2.20.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-P0qTxUdyM2Ect2+GSLC0vJbAxvaLXQi1ZMFujBnGKQ0=";
  };

  npmDepsHash = "sha256-RIhVSRjqzFawXaRZHAUwGodnNerGz+I3GbPFsP5qESY=";
=======
    hash = "sha256-RvnoQRVJlZNqfmOa2c1s/ZuA0Ej7pZ7WcXM+31t22eY=";
  };

  npmDepsHash = "sha256-93w0ZWtrLfYRBa5Ps4duSRoiI4hu9AoK7GZRRH4zmL0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    cp -R out $out
  '';

  env = {
    CYPRESS_INSTALL_BINARY = 0;
  };

<<<<<<< HEAD
  meta = {
    description = "NetBird Management Service Web UI Panel";
    homepage = "https://github.com/netbirdio/dashboard";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "NetBird Management Service Web UI Panel";
    homepage = "https://github.com/netbirdio/dashboard";
    license = licenses.bsd3;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      patrickdag
    ];
  };
}
