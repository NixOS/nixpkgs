{ fetchFromGitHub, lib, rustPlatform, stdenv, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = version;
    sha256 = "08d6h7xwcgycw5bdzwwc6aaikcrw3yc7inkiydgml9q261kql7zl";
    # upstream includes an outdated Cargo.lock that stops cargo from compiling
    postFetch = ''
      mkdir -p $out
      tar xf $downloadedFile --strip=1 -C $out
      substituteInPlace $out/Cargo.lock \
        --replace 0.8.6 ${version}
    '';
  };

  cargoSha256 = "1scrqm7fs8y7anfiigimj7y5rjxcc2qvrxiq8ai7k5cwfc4v1ghm";

  buildInputs = lib.optional stdenv.isDarwin SystemConfiguration;

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
