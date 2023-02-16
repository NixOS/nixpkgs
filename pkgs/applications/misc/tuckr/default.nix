{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tuckr";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = version;
    sha256 = "sha256-mpI0iAGMIzGGdObH5bfyA3iioNdquzLDZoSWxbAOsJ0=";
  };

  cargoPatches = [ ./update-cargo-lock.diff ];

  cargoSha256 = "sha256-tm8fS8IWxWF4Vh+3QaCiruglZijdOic34vfAyxflDNM=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = with lib; {
    description = "A super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mimame ];
  };
}
