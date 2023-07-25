{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "flaca";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Blobfolio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RXMqPpQM2h6EtIIH8Ix31euC7zK3v2QohZqouNlK7rM=";
  };

  # upstream does not provide a Cargo.lock
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A CLI tool to losslessly compress JPEG and PNG images";
    longDescription = "A CLI tool for x86-64 Linux machines that simplifies the task of maximally, losslessly compressing JPEG and PNG images for use in production web environments";
    homepage = "https://github.com/Blobfolio/flaca";
    maintainers = with maintainers; [ zzzsy ];
    platforms = platforms.linux;
    license = licenses.wtfpl;
  };
}
