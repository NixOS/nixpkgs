{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0aNtBf3np9cq9JTgHRWy73i4AKaVEOluhSMSUyobduI=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-DXPpW7vls4yDEMiRrqDndxEKSA7Uncrt6n8nmsBXHcU=";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://xplr.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 thehedgeh0g ];
  };
}
