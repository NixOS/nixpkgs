{
  fetchFromGitHub,
  hicolor-icon-theme,
  just,
  lib,
  pop-icon-theme,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-icons";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-7gWCRBiE+XJX1JSjopyPN4bIIgZih6ZKGVSA7wBq3i0=";
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

  meta = with lib; {
    description = "System76 COSMIC icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with licenses; [ cc-by-sa-40 ];
    platforms = platforms.all;

    maintainers = with maintainers; [
      a-kenji
      thefossguy
    ];
  };
}
