{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-source-record";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-record";
    rev = version;
    hash = "sha256-Q4T0KYaCQiGQ37ApmlCJdW4I71RFf5tnoexrlhoW+0k=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=deprecated-declarations" ];

  cmakeFlags = [ "-DBUILD_OUT_OF_TREE=On" ];

  postInstall = ''
    rm -rf $out/{data,obs-plugins}
  '';

  meta = {
    description = "OBS Studio plugin to make sources available to record via a filter";
    homepage = "https://github.com/exeldro/obs-source-record";
    maintainers = with lib.maintainers; [
      robbins
      elzorrorebelde
    ];
    license = lib.licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
