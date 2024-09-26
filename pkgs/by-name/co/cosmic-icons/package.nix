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
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "341c84467fd863f0319cadf49b3d4bac1bf3029a";
    hash = "sha256-VA2QKuzTQBgubfjPXdpejFtZxqOZUXds/fZrfN6/8Nk=";
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
