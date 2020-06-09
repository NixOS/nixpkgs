{ stdenv, lib, fetchFromGitHub, cmake, libuchardet, pkgconfig, shntool, flac
, opusTools, vorbis-tools, mp3gain, lame, wavpack, vorbisgain, gtk3, qtbase
, qttools, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "flacon";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "0p5z6rwckda0lkljrrvx6i90fazj53cxg9pasfmi8154j1z72dj2";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];
  buildInputs = [ qtbase qttools libuchardet ];

  bin_path = lib.makeBinPath [
    shntool
    flac
    opusTools
    vorbis-tools
    mp3gain
    lame
    wavpack
    vorbisgain
  ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix PATH : "$bin_path";
  '';

  meta = with stdenv.lib; {
    description =
      "Extracts audio tracks from an audio CD image to separate tracks";
    homepage = "https://flacon.github.io/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ snglth ];
  };
}
