{ lib
, stdenvNoCC
, fetchFromGitHub
, just
, pop-icon-theme
, hicolor-icon-theme
, unstableGitUpdater
}:
stdenvNoCC.mkDerivation rec {
  pname = "cosmic-icons";
  version = "0-unstable-2024-05-21";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "9aad1ab6d5538938e69955b5f74576ac020be425";
    sha256 = "sha256-ln2spVA8dlXi/B0ro/FIoWiIClPmwH9E9IqhrKPedys=";
  };

  nativeBuildInputs = [ just ];

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  propagatedBuildInputs = [
    pop-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "System76 Cosmic icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ a-kenji ];
  };
}
