{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "sha256-1pc3XBsBQr9xBFIVOWZnA4YlgFYwJJJyV05W67hXG8k=";
  };

  vendorHash = "sha256-cN7YJDw5lOOngXJBeXa7V0Y/CjEydBMk3hvyfd0VL5I=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/lokalise-cli-2-go $out/bin/lokalise2
  '';

  meta = {
    description = "Translation platform for developers. Upload language files, translate, integrate via API";
    homepage = "https://lokalise.com";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ timstott ];
    mainProgram = "lokalise2";
  };
}
