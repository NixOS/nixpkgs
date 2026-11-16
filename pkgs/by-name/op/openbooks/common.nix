{ lib, fetchFromGitHub }:
rec {
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "evan-buss";
    repo = "openbooks";
    rev = "v${version}";
    hash = "sha256-gznaMcj8/9xW8wvz/pQaw4tY/hDW8K6duFfJD74E47E=";
  };

  meta = {
    homepage = "https://evan-buss.github.io/openbooks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
