{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pinyin-tool";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "briankung";
    repo = "pinyin-tool";
    rev = version;
    sha256 = "1gwqwxlvdrm4sdyqkvpvvfi6jh6qqn6qybn0z66wm06k62f8zj5b";
  };

  cargoHash = "sha256-SOeyk2uWCdO99ooQc2L1eXlV77lR4DLBK6PnV6Ur49A=";

  meta = with lib; {
    description = "Simple command line tool for converting Chinese characters to space-separate pinyin words";
    mainProgram = "pinyin-tool";
    homepage = "https://github.com/briankung/pinyin-tool";
    license = licenses.mit;
  };
}
