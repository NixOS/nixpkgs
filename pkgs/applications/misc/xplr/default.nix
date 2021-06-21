{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1bgylz2x44rjxpd6dvd44pr57f18di0nj5sbqh4my8lkanr7isli";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "07rlmz4rkgdcvr0dvbrz56s5vacxcvy09rgz70kr692xlpym4jvq";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
