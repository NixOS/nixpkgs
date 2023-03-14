{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
    rev = "${version}";
    sha256 = "sha256-ZyqE6xFNsOwTBbLLn14jwNp9UkagTRgAQS+SEl+POaY=";
  };

  vendorHash = "sha256-Wsejz/vYaT/maN7dYcrXPTXg30jZaldaslXbHcgHlRs=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}
