{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "convbin";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "mateoconlechuga";
    repo = "convbin";
    tag = "v${version}";
    sha256 = "sha256-k0hwBdjOweFoAE6jzhlRFZsMOVDDpi4R4LHA7SwO3os=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile --replace "-flto" ""
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  checkPhase = ''
    pushd test
    patchShebangs test.sh
    ./test.sh
    popd
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bin/convbin $out/bin/convbin
  '';

  meta = {
    description = "Converts files to other formats";
    longDescription = ''
      This program is used to convert files to other formats,
      specifically for the TI84+CE and related calculators.
    '';
    homepage = "https://github.com/mateoconlechuga/convbin";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "convbin";
  };
}
