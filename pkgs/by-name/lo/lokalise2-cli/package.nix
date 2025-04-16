{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "sha256-9d5rlVyGPLNzlKzGq/XJleiKvLtkE0AttIiH6NYUwFo=";
  };

  vendorHash = "sha256-thD8NtG9uVI4KwNQiNsVCUdyUcgAmnr+szsUQ2Ika1c=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/lokalise-cli-2-go $out/bin/lokalise2
  '';

  meta = with lib; {
    description = "Translation platform for developers. Upload language files, translate, integrate via API";
    homepage = "https://lokalise.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timstott ];
    mainProgram = "lokalise2";
  };
}
