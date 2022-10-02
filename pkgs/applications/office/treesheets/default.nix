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
  version = "unstable-2022-09-26";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
    rev = "4778c343ac78a3b3ccdaf079187b53d8cd64e235";
    sha256 = "UyltzT9B+7/hME7famQa/XgrDPaNw3apwchKgxwscOo=";
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
