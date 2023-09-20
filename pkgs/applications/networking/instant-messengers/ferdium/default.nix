{ lib, mkFranzDerivation, fetchurl, xorg, nix-update-script }:

mkFranzDerivation rec {
  pname = "ferdium";
  name = "Ferdium";
  version = "6.4.1";
  src = fetchurl {
    url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-amd64.deb";
    hash = "sha256-Oai5z6/CE/R2rH9LBVhY7eaKpF8eIIYI+3vjJPbq+rw=";
  };

  extraBuildInputs = [ xorg.libxshmfence ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--override-filename" ./default.nix ];
    };
  };

  meta = with lib; {
    description = "All your services in one place built by the community";
    homepage = "https://ferdium.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ magnouvean ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
