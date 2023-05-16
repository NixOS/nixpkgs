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
<<<<<<< HEAD
  version = "unstable-2023-09-07";
=======
  version = "unstable-2023-05-04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "treesheets";
<<<<<<< HEAD
    rev = "8d4073d2fedfc9952c3a06fd9d9be17ffeb50cf0";
    sha256 = "BpE402BL9PHx6g2gkeRBP4F2XLAjca3KpyXwFDWayio=";
=======
    rev = "3694b16809daaa59b9198cd9645662e2a8cf4650";
    sha256 = "NShLLBTBS88UXWWjsSeMVxj8HnnN4yA8gmz83wdpIzE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
