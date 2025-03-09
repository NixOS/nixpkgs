{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "crypto-tracker";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "Nox04";
    repo = "crypto-tracker";
    rev = "v${version}";
    hash = "sha256-8tTaXpHZWcDq0Jfa9Hf258VYwfimLhYjCAzD4X/Ow0s=";
  };

  vendorHash = "sha256-ORdDrZ61u76mz2oZyxfdf7iuo9SnuQeDxESt9lORhgQ=";

  meta = with lib; {
    description = "Program to retrieve the latest price for several cryptocurrencies using the CoinMarketCap API";
    homepage = "https://github.com/Nox04/crypto-tracker";
    license = licenses.mit;
    maintainers = with maintainers; [ tiredofit ];
    mainProgram = "crypto-tracker";
  };
}
