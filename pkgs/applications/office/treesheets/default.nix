{ lib
, stdenv
, fetchFromGitHub
, wxGTK
, cmake
, ninja
, wrapGAppsHook
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "treesheets";
  version = "unstable-2022-03-12";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
    rev = "120c10d4d9ea1ce76db5c1bbd6f5d705b397b57d";
    sha256 = "oXgOvvRoZpueEeWnD3jsc6y5RIAzkXzLeEe7BSErBpw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    wxGTK
  ];

  NIX_CFLAGS_COMPILE = "-DPACKAGE_VERSION=\"${builtins.replaceStrings [ "unstable-" ] [ "" ] version}\"";

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Free Form Data Organizer";

    longDescription = ''
      The ultimate replacement for spreadsheets, mind mappers, outliners,
      PIMs, text editors and small databases.

      Suitable for any kind of data organization, such as Todo lists,
      calendars, project management, brainstorming, organizing ideas,
      planning, requirements gathering, presentation of information, etc.
    '';

    homepage = "https://strlen.com/treesheets/";
    maintainers = with maintainers; [ obadz avery ];
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
