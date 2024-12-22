{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-source-record";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-record";
    rev = version;
    sha256 = "sha256-ArvVBMQw3Po2QlDzSTPHZn1UNAi1tERrQeGcQKCM0CE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  cmakeFlags = [ "-DBUILD_OUT_OF_TREE=On" ];

  postInstall = ''
    rm -rf $out/{data,obs-plugins}
  '';

  meta = with lib; {
    description = "OBS Studio plugin to make sources available to record via a filter";
    homepage = "https://github.com/exeldro/obs-source-record";
    maintainers = with maintainers; [
      robbins
      shackra
    ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
