{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "10jmawxzqgz7gjg1xdna9q2v6l1qlf83ybbqxcbx6941s15lgs7x";
  };

  cargoSha256 = "1888bvkpalfcw9bc9zmf9bmil6x35l9ia31x6mx1h2dvrfpw3bb1";

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
