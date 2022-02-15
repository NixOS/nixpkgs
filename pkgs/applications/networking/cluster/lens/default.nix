{ lib
, fetchFromGitHub
, yarn2nix-moretea
, nodejs-14_x
, yarn
, fetchYarnDeps
}:
let
  yarn2nix = yarn2nix-moretea.override { nodejs = nodejs-14_x; };
in
yarn2nix.mkYarnPackage rec {
  pname = "lens";
  version = "5.3.4";

  src = fetchFromGitHub {
    owner = "lensapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dVanSi6VkLVUoEK0r8vqkJztCjD9ulx8LeNsMnikh7Q=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-KryL1Q3Sar14FHJq1cnH/WgnqZCWryrjnB3wvOCslAE=";
  };

  distPhase = ":"; # disable useless $out/tarballs directory

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks otavio ];
    platforms = platforms.linux;
  };
}
