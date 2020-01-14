{ stdenv, lib, fetchFromGitHub, cmake, libuchardet, pkgconfig
, shntool, flac, opusTools, vorbis-tools, mp3gain, lame, wavpack, vorbisgain
, gtk3
, qtbase, qttools, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "flacon";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "05pvg5xhc2azwzld08m81r4b2krqdbcbm5lmdvg2zkk67xq9pqyd";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];
  buildInputs = [ qtbase qttools libuchardet ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix PATH : "${lib.makeBinPath [ shntool flac opusTools vorbis-tools
     mp3gain lame wavpack vorbisgain ]}"
  '';

  meta = with stdenv.lib; {
    description = "Extracts audio tracks from an audio CD image to separate tracks.";
    homepage = https://flacon.github.io/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ snglth ];
  };
}
