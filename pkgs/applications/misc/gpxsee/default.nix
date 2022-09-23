{ lib, stdenv, fetchFromGitHub, nix-update-script, substituteAll
, qmake, qttools, qttranslations, qtlocation, qtpbfimageplugin, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gpxsee";
  version = "11.4";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    hash = "sha256-aePX82B810I45n2t0OVCt1FlmkVKWgNgzCD71lYyngU=";
  };

  patches = (substituteAll {
    # See https://github.com/NixOS/nixpkgs/issues/86054
    src = ./fix-qttranslations-path.diff;
    inherit qttranslations;
  });

  buildInputs = [ qtlocation qtpbfimageplugin ];

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  preConfigure = ''
    lrelease gpxsee.pro
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    homepage = "https://www.gpxsee.org/";
    changelog = "https://build.opensuse.org/package/view_file/home:tumic:GPXSee/gpxsee/gpxsee.changes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ womfoo sikmir ];
    platforms = platforms.unix;
  };
}
