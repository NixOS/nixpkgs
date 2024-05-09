{ stdenv, pkgs, lib }:

pkgs.stdenv.mkDerivation rec {
  name = "cros-ectool";
  nativeBuildInputs = with pkgs; [ cmake ninja pkg-config libusb libftdi1 ];
  src = pkgs.fetchFromGitLab {
    domain = "gitlab.howett.net";
    owner = "DHowett";
    repo = "ectool";
    rev = "39d64fb0e79e874cfe9877af69158fc2520b1a80";
    hash = "sha256-SHRnyqicFlviBDu3aH+uKVUstVxpIhZV6JSuZOgOwXU=";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp src/ectool $out/bin/ectool
  '';
  meta = with lib; {
    description = "ectool for ChromeOS devices";
    homepage = "https://gitlab.howett.net/DHowett/ectool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ChocolateLoverRaj ];
    platforms = platforms.linux;
    mainProgram = "ectool";
  };
}
