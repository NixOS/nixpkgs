{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  just,
  pop-icon-theme,
  hicolor-icon-theme,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation rec {
  pname = "cosmic-icons";
  version = "0-unstable-2024-05-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "f48101c38db7e725d31591ec49896a2f525886e2";
    sha256 = "sha256-M9n09uEM4ee8FZYTsaAu+8E0YRxQAGBvylKDHv1dp5M=";
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
