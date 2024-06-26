{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "maiko";
  version = "2021-04-14";
  src = fetchFromGitHub {
    owner = "Interlisp";
    repo = "maiko";
    rev = "91fe7d51f9d607bcedde0e78e435ee188a8c84c0";
    hash = "sha256-Y+ngep/xHw6RCU8XVRYSWH6S+9hJ74z50pGpIqS2CjM=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ xorg.libX11 ];
  installPhase = ''
    runHook preInstall
    find . -maxdepth 1 -executable -type f -exec install -Dt $out/bin '{}' \;
    runHook postInstall
  '';
  meta = with lib; {
    description = "Medley Interlisp virtual machine";
    homepage = "https://interlisp.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry ];
    inherit (xorg.libX11.meta) platforms;
  };
}
