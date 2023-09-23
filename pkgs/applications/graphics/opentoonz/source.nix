# opentoonz's source archive contains both opentoonz's source and a modified
# version of libtiff that opentoonz requires.

{ fetchFromGitHub, }: rec {
  versions = {
    opentoonz = "1.6.0";
    libtiff = "4.0.3";  # The version in thirdparty/tiff-*
  };

  src = fetchFromGitHub {
    owner = "opentoonz";
    repo = "opentoonz";
    rev = "v${versions.opentoonz}";
    hash = "sha256-8QZyIMYDqvhQUW5etSjugQRBWhsN3w/QUGC0RfnqYDc=";
  };
}
