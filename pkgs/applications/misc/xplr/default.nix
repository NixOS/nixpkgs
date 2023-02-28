{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iPcxDNtwWnvFljZw052aw/ekCahyFBNt/zbUAdaWJA8=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-Sn7ZcNdmMDQJHn99iTJX9c3uVhaGpRvEgdoJFmIUgeU=";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g ];
  };
}
