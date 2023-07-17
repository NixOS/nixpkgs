{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, wrapGAppsHook
, makeWrapper
, wxGTK
, Cocoa
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "treesheets";
  version = "unstable-2023-07-15";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
    rev = "65855787063b62ca048aa1cb9b5e6e42a009a150";
    sha256 = "Hb+fP5hL2x9BH16jRPMjGDz8EelI1n4Scl3tWheyeh8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapGAppsHook
    makeWrapper
  ];

  buildInputs = [
    wxGTK
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  env.NIX_CFLAGS_COMPILE = "-DPACKAGE_VERSION=\"${builtins.replaceStrings [ "unstable-" ] [ "" ] version}\"";

  postInstall = lib.optionalString stdenv.isDarwin ''
    shopt -s extglob
    mkdir -p $out/{share/treesheets,bin}
    mv $out/!(share) $out/share/treesheets
    makeWrapper $out/{share/treesheets,bin}/treesheets \
      --chdir $out/share/treesheets
  '';

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
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
