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
  version = "unstable-2023-04-09";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
    rev = "afeb34a1c5255484eea912edf0cc175cae5eea12";
    sha256 = "KFGI3p9V8clOACQ+kxhLazOqcSm7Ou/84+1JrEA1rC0=";
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
