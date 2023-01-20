{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-POOXawhxrPT2UgbSZE3r0br7cqJ0ao7MpycrPYa/oCc=";
  };

  cargoSha256 = "sha256-2c34YarMFw2CK+7zn41GL5tXfXfnw3NvGtgSlPH5d64=";

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    changelog = "https://github.com/svenstaro/genact/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
