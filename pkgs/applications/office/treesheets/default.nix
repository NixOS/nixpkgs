{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  wrapGAppsHook3,
  makeWrapper,
  wxGTK,
  Cocoa,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "treesheets";
  version = "0-unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
    rev = "dfbea81adc25e109dfe5482cc09508f612aaa84d";
    hash = "sha256-Hh42q7soCCXY7AMTH3bLMlUJ72y3QOyC/1nFUQPMFaM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs =
    [
      wxGTK
    ]
    ++ lib.optionals stdenv.isDarwin [
      Cocoa
    ];

  env.NIX_CFLAGS_COMPILE = "-DPACKAGE_VERSION=\"${
    builtins.replaceStrings [ "unstable-" ] [ "" ] version
  }\"";

  postInstall = lib.optionalString stdenv.isDarwin ''
    shopt -s extglob
    mkdir -p $out/{share/treesheets,bin}
    mv $out/!(share) $out/share/treesheets
    makeWrapper $out/{share/treesheets,bin}/treesheets \
      --chdir $out/share/treesheets
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      hardcodeZeroVersion = true;
    };
  };

  meta = with lib; {
    description = "Free Form Data Organizer";
    mainProgram = "treesheets";

    longDescription = ''
      The ultimate replacement for spreadsheets, mind mappers, outliners,
      PIMs, text editors and small databases.

      Suitable for any kind of data organization, such as Todo lists,
      calendars, project management, brainstorming, organizing ideas,
      planning, requirements gathering, presentation of information, etc.
    '';

    homepage = "https://strlen.com/treesheets/";
    maintainers = with maintainers; [ obadz ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
