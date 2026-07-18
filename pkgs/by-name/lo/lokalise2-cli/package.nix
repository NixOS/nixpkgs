{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lokalise2-cli";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vMredBTXwlpRK3Y90CRV00mdpJu6SoqfPNH1AMUOsPA=";
  };

  vendorHash = "sha256-NS4nKoZSJ8M/n18Y2vQb5MuKBBjS6SGRoKJi5B2J68g=";

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
})
