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
  version = "unstable-2024-02-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "ee87327736728a9fb5a70c8688e9000f72829343";
    sha256 = "sha256-W4t5uTkiOVGGHZEqD5tGbEPhHbNZp5qnYYHDG8N70vQ=";
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
