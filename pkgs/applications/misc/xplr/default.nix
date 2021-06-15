{ lib, stdenv, rustPlatform, fetchCrate, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.14.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "08gb4dnnzdy3whn2411xmar1wpvmc014scbniicksra8p1xizh0b";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "1yxbirqf6c4bc364gw0nnjrjvhvjy2j2pbmvlpakv0bmyfphhb95";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
