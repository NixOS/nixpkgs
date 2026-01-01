{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-3d-effect";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-3d-effect";
    rev = version;
    sha256 = "sha256-5cPXfEcKIATFQktjIN5lmYjvakYe/k26aHKlJz5FqPE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

<<<<<<< HEAD
  meta = {
    description = "Plugin for OBS Studio adding 3D effect filter";
    homepage = "https://github.com/exeldro/obs-3d-effect";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "Plugin for OBS Studio adding 3D effect filter";
    homepage = "https://github.com/exeldro/obs-3d-effect";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (obs-studio.meta) platforms;
  };
}
