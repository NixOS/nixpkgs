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
  version = "unstable-2024-02-07";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "edd405ed84186ee24307deb7da6f25efc85986e9";
    sha256 = "sha256-qz39vI9bRac9ZQg8FPrwv3/TW5zGlsvs2me5aE5vvZo=";
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
