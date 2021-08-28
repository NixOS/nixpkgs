{ stdenv, mkDerivation, lib, fetchFromGitHub, substituteAll
, qmake, qttools, qttranslations
}:

mkDerivation rec {
  pname = "gpxlab";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "BourgeoisLab";
    repo = "GPXLab";
    rev = "v${version}";
    sha256 = "080vnwcciqblfrbfyz9gjhl2lqw1hkdpbgr5qfrlyglkd4ynjd84";
  };

  patches = (substituteAll {
    # See https://github.com/NixOS/nixpkgs/issues/86054
    src = ./fix-qttranslations-path.patch;
    inherit qttranslations;
  });

  nativeBuildInputs = [ qmake qttools ];

  preConfigure = ''
    lrelease GPXLab/locale/*.ts
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GPXLab/GPXLab.app $out/Applications
    wrapQtApp $out/Applications/GPXLab.app/Contents/MacOS/GPXLab
  '';

  meta = with lib; {
    homepage = "https://github.com/BourgeoisLab/GPXLab";
    description = "Program to show and manipulate GPS tracks";
    longDescription = ''
      GPXLab is an application to display and manage GPS tracks
      previously recorded with a GPS tracker.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
