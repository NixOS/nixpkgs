{ lib, mkFranzDerivation, fetchurl, xorg, nix-update-script }:

mkFranzDerivation rec {
  pname = "ferdium";
  name = "Ferdium";
  version = "6.4.0";
  src = fetchurl {
    url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-amd64.deb";
    sha256 = "sha256-zIGtGmCtQn26rxDsZfPKUZAFnBaWYRhfVJdazPyZ/g0=";
  };

  extraBuildInputs = [ xorg.libxshmfence ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--override-filename" ./default.nix  ];
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
