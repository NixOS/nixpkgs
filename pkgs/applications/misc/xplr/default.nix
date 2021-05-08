{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mqxnahhbf394niyc8i6gk2y3i7lj9cj71k460r58cmir5fch82m";
  };

  cargoSha256 = "1dfcmkfclkq5b103jl98yalcl3mnvsq8xpkdasf72d3wgzarih16";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
