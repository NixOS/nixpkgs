{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "1c2zqvkzkrj8rcz226vfk43yw113b1fdcz2gx0xh8fs72arqx6wh";
  };

  cargoSha256 = "1888bvkpalfcw9bc9zmf9bmil6x35l9ia31x6mx1h2dvrfpw3bb1";

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ma27 ];
  };
}
