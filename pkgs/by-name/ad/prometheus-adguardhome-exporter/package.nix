{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  name = "adguard-exporter";
  version = "0-unstable-2020-11-07";

  src = fetchFromGitHub {
    owner = "Griffen8280";
    repo = "adguard-exporter";
    rev = "5c18890cdce3dd3068904846df8a7d25aa0e4bf5";
    sha256 = "sha256-mrZ8I2KCd32XXDZoN3SuuhkF5ePpsUGDMAkcPO4qPs8=";
  };

  vendorHash = "sha256-nm+B7Qjtx/NHqGuaqVKt2kM9ZvSNYHhTfLxHeu4hlT4=";

  meta = with lib; {
    description = "Adguard exporter based on eko/pihole-exporter";
    homepage = "https://github.com/Griffen8280/adguard-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
