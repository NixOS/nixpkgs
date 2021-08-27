{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1i601db28zvxrsvjbsx0p257pcyxm0px82cx3hq49xxgwidk2m6b";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "0vsd6nq0rkn85ynn6wxf5hnjijfr64gh7pxyxbmk14v8y5vyg0kc";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
