{ lib
, stdenv
, fetchFromGitHub
, qmake
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "yuview";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "IENT";
    repo = "YUView";
    rev = "v.${version}";
    sha256 = "sha256-2mNIuyY/ni+zkUc8V/iXUEa7JeBJyOnNod7friMYAm8=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  patches = [ ./disable_version_check.patch ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://ient.github.io/YUView";
    description = "YUV Viewer and Analysis Tool";
    longDescription = ''
      YUView is a Qt based YUV player with an advanced analytic toolset for
      Linux, Windows and Mac. At its core, YUView is a powerful YUV player that
      can open and show almost any YUV format. With its simple interface it is
      easy to navigate through sequences and inspect details and a side by side
      and comparison view can help to spot differences between two sequences. A
      sophisticated statistics renderer can overlay the video with supplemental
      information. More features include playlists, support for visual tests and
      presentations, support of compressed formats (through libde265 and
      FFmpeg), support for raw RGB files as well as image files and image
      sequences, and many more. Further information can be found in the YUV help
      in the application itself or in our wiki.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leixb ];
    platforms = platforms.unix;
  };
}
