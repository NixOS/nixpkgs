{ buildGoModule, fetchFromSourcehut, lib }:
buildGoModule rec {
  pname = "ratt";
  version = "unstable-2022-01-11";

  src = fetchFromSourcehut {
    owner = "~ghost08";
    repo = "ratt";
    rev = "eac7e14b15ad4e916e7d072780397c414c740630";
    hash = "sha256-/WzPF98MovNg4t5NJhL2Z1bAFDG/3I56M9YgRJF7Wjk=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-NW5B9oO/LJqPigvOcMeL4hQLKmAL01I2Ff41y169BTQ=";

  # tests try to access the internet to scrape websites
  doCheck = false;

  meta = with lib; {
    description = "A tool for converting websites to rss/atom feeds";
    homepage = "https://git.sr.ht/~ghost08/ratt";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
