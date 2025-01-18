{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "supergfxctl-plasmoid";
  version = "2.1.1";

  src = fetchFromGitLab {
    owner = "jhyub";
    repo = "supergfxctl-plasmoid";
    rev = "refs/tags/v${version}";
    hash = "sha256-Un2uVTde18qloZoWk6bbscyvsBTIAdK1CfxYAZg1+F4=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.libplasma
  ];

  meta = with lib; {
    description = "KDE Plasma plasmoid for supergfxctl";
    longDescription = ''
      KDE Plasma plasmoid for supergfxctl
      Built as a C++/QML Plasmoid
    '';
    license = licenses.mpl20;
    homepage = "https://gitlab.com/Jhyub/supergfxctl-plasmoid";
    maintainers = with maintainers; [ johnylpm ];
  };
}
