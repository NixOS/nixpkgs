{ lib, rustPlatform, fetchFromGitHub, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-eDozoYN2iOFUY/w7Gjki4nnASyZo4V/YGPjdX2xjNGY=";
  };

  cargoHash = "sha256-UZrVZBdaiIrMajePKWXDZI+Z+nXTGadNKmoa3gdfzp4=";

  passthru.tests = nixosTests.cntr;

  meta = with lib; {
    description = "A container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
    mainProgram = "cntr";
  };
}
