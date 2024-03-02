{ fetchurl }:
let
  build = "2023.5.310801-latest";
in
{
  pname = "lens-desktop";
  version = "6.5.2";
  sources = {
    x86_64-darwin = fetchurl {
      sha256 = "sha256-AGU1kOQEYBAGqWaxftqSNVdPEblPDujKSBjMeaVNx6M=";
      url = "https://api.k8slens.dev/binaries/Lens-${build}.dmg";
    };
    aarch64-darwin = fetchurl {
      sha256 = "sha256-Xx+6GPAfjioTrqfFS7cFh6deraR+TtqLlwLbVQxfN8g=";
      url = "https://api.k8slens.dev/binaries/Lens-${build}-arm64.dmg";
    };
    x86_64-linux = fetchurl {
      sha256 = "sha256-DPgeAhM8k6RXg1Qw2bqJFLPh5q2o7Va6EAe/InQNXLg=";
      url = "https://api.k8slens.dev/binaries/Lens-${build}.x86_64.AppImage";
    };
  };
}
