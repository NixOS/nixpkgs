{
  lib,
  fetchFromGitHub,
  kdePackages,
}:
kdePackages.mkKdeDerivation rec {
  pname = "plasma-applet-appgrid";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "xarbit";
    repo = "plasma6-applet-appgrid";
    rev = "v${version}";
    hash = "sha256-N5o1fFcnQ074P4MoGWA3rmJOFmFjE+cU2op0EGsOxIg=";
  };

  __structuredAttrs = true;

  extraBuildInputs = with kdePackages; [
    plasma-desktop
    qtdeclarative
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Grid-centered application launcher";
    inherit (src.meta) homepage;
    license = with licenses; [
      gpl2
      cc0
      mit
    ];
    maintainers = with maintainers; [ somasis ];
  };
}
