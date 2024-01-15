{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-Fwc8S48zCE5s66gNVhJi9Y45v7rKo9K9dYQoao33mDE=";
  };

  vendorHash = "sha256-PsbPAwjqT2PP6DtrzHaQox1er/LAkiHPMVMLH4gmfpg=";

  # pings websites during testing
  doCheck = false;

  meta = with lib; {
    description = "Pixiv FANBOX Downloader";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = licenses.mit;
    maintainers = [ maintainers.moni ];
  };
}
