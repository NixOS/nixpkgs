{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "01jiqizg1ywvrrwhqzfqzbaqrzyfaqm66sixas0mpyzmd6cdwmh6";
  };

  cargoSha256 = "0hah0qfgnl4w2h0djyh4xx1jks5dkzwin01qw001dqiasl60prn2";

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ma27 ];
  };
}
