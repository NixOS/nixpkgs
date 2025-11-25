{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-dir-watch-media";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-dir-watch-media";
    rev = version;
    sha256 = "sha256-zvg8Bu5wlcQe91ggteEj7G9Kx+mY1R6EN64T13vp7pc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio adding a filter that can watch a directory for media files";
    homepage = "https://github.com/exeldro/obs-dir-watch-media";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
