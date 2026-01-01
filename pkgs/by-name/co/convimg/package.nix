{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "convimg";
  version = "9.4";

  src = fetchFromGitHub {
    owner = "mateoconlechuga";
    repo = "convimg";
    tag = "v${version}";
    hash = "sha256-5insJ391Usef8GF3Yh74PEqE534zitQg9udFRPcz69g=";
    fetchSubmodules = true;
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  checkPhase = ''
    pushd test
    patchShebangs test.sh
    ./test.sh
    popd
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bin/convimg $out/bin/convimg
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Image palette quantization";
    longDescription = ''
      This program is used to convert images to other formats,
      specifically for the TI84+CE and related calculators.
    '';
    homepage = "https://github.com/mateoconlechuga/convimg";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "convimg";
  };
}
