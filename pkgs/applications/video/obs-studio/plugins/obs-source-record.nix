{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, obs-studio }:

stdenv.mkDerivation rec {
  pname = "obs-source-record";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-record";
    rev = version;
    sha256 = "sha256-H65uQ9HnKmHs52v3spG92ayeYH/TvmwcMoePMmBMqN8=";
  };

  patches = [
    # fix obs 29.1 compatibility
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/exeldro/obs-source-record/pull/83.diff";
      hash = "sha256-eWOjHHfoXZeoPtqvVyexSi/UQqHm8nu4FEEjma64Ly4=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    rm -rf $out/{data,obs-plugins}
  '';

  meta = with lib; {
    description = "OBS Studio plugin to make sources available to record via a filter";
    homepage = "https://github.com/exeldro/obs-source-record";
    maintainers = with maintainers; [ robbins ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
