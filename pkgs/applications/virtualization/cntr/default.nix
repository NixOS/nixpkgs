{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-4ogyOKuz6702/sOQNvE+UP+cvQrPPU3VjL4b0FUfRNw=";
  };

  cargoSha256 = "sha256-lblvun2T1qpFiowld77Ti2MFPzhs5pOWWRbErORXYCM=";

  meta = with lib; {
    description = "A container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
