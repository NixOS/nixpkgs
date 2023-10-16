{ stdenv, lib, fetchFromGitHub, cmake, libuchardet, pkg-config, shntool, flac
, opusTools, vorbis-tools, mp3gain, lame, taglib, wavpack, vorbisgain, gtk3, qtbase
, qttools, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "flacon";
  version = "11.3.0";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "sha256-jzpD8+zhIbOYgSNsoE1Pay+FiPXtRCd6Zz6HHkzWAkY=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ qtbase qttools libuchardet taglib ];

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

  meta = with lib; {
    description =
      "Extracts audio tracks from an audio CD image to separate tracks";
    homepage = "https://flacon.github.io/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ snglth ];
  };
}
