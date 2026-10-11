{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fftw,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "genalyzer";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "genalyzer";
    tag = "v${version}";
    hash = "sha256-3yrqUrMx5szhb6T+U2sYETEYFx8Qo6huSMC311QFLlo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "DESTINATION /usr/local/lib" "DESTINATION lib"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for computing RF performance metrics in data converters";
    homepage = "https://github.com/analogdevicesinc/genalyzer";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
  };
}
