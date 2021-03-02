{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-RwpRlcShvZVBR22xkJz50p10SEULXM9/gqVGNXiSM3M=";
  };

  cargoSha256 = "sha256-ezxIDaU270V5oqm1m8mt9QXu/SsrKomaxM2TnH+bSUY=";

  meta = with lib; {
    description = "A container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
