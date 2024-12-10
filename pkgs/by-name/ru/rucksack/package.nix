{
  lib,
  stdenv,
  fetchFromGitHub,
  liblaxjson,
  cmake,
  freeimage,
}:

stdenv.mkDerivation rec {
  version = "3.1.0";
  pname = "rucksack";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "rucksack";
    rev = version;
    sha256 = "0bcm20hqxqnq1j0zghb9i7z9frri6bbf7rmrv5g8dd626sq07vyv";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    liblaxjson
    freeimage
  ];

  meta = with lib; {
    description = "Texture packer and resource bundler";
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ]; # fails on Darwin and AArch64
    homepage = "https://github.com/andrewrk/rucksack";
    license = licenses.mit;
    maintainers = [ maintainers.andrewrk ];
  };
}
