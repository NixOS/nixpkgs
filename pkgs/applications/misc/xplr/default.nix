{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1znb6n9xbzbi9sif76xlwnqrzkh50g9yz6k36m0hm5iacd1fapab";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "0gbhkpha02ymr861av0fmyz6h007ajwkqcajq8hrnfzjk8rii47m";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
