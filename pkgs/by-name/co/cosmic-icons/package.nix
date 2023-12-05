{ lib
, stdenvNoCC
, fetchFromGitHub
, just
, pop-icon-theme
, hicolor-icon-theme
}:
stdenvNoCC.mkDerivation rec {
  pname = "cosmic-icons";
  version = "unstable-2023-08-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "14d8e2048087be1ad444f9b3ebb75885509f72c6";
    sha256 = "sha256-WbdgHmTn403x95x9wEYL0T9ksbN+YLzEB2yE0UrF9T0=";
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
    description = "System76 Cosmic icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ a-kenji ];
  };
}
