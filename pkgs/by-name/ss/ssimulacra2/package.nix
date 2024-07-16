{ lib
, stdenv
, fetchFromGitHub
, ninja
, cmake
, libpng
, libhwy
, lcms2
, giflib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssimulacra2";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "cloudinary";
    repo = "ssimulacra2";
    hash = "sha256-gOo8WCWMdXOSmny0mQSzCvHgURQTCNBFD4G4sxfmXik=";
    rev = "tags/v${finalAttrs.version}";
  };

  nativeBuildInputs = [
    ninja
    cmake
  ];

  buildInputs = [
    libpng
    libhwy
    lcms2
    giflib
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  installPhase = ''
    runHook preInstall
    install -m 755 -D ssimulacra2 -t $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/cloudinary/ssimulacra2";
    maintainers = [ maintainers.viraptor ];
    license = licenses.bsd3;
    description = "Perceptual image comparison tool";
  };
})
