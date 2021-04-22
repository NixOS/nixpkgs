{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "xplr";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = name;
    rev = "v${version}";
    sha256 = "0m28jhkvz46psxbv8g34v34m1znvj51gqizaxlmxbgh9fj3vyfdb";
  };

  cargoSha256 = "0q2k8bs32vxqbnjdh674waagpzpb9rxlwi4nggqlbzcmbqsy8n6k";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
