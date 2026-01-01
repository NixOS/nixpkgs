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

<<<<<<< HEAD
  meta = {
    description = "Plugin for OBS Studio adding a filter that can watch a directory for media files";
    homepage = "https://github.com/exeldro/obs-dir-watch-media";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Plugin for OBS Studio adding a filter that can watch a directory for media files";
    homepage = "https://github.com/exeldro/obs-dir-watch-media";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (obs-studio.meta) platforms;
  };
}
