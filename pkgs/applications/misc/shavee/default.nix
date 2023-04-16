{ lib, pkgs, rustPlatform, fetchFromGitHub, pkg-config, openssl, zlib,stdenv, pam }:

rustPlatform.buildRustPackage rec {
  pname = "shavee";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ashuio";
    repo = "shavee";
    rev = "v${version}";
    sha256 = "sha256-41wJ3QBZdmCl7v/6JetXhzH2zF7tsKYMKZY1cKhByX8=";
  };

  cargoSha256 = "sha256-iNGn5KknSNgazFSu6Nur7AkKVb6qKMxuFwTdCz5djWU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    pam
  ];

   # these tests require network access
  checkFlags = [
    "--skip=filehash::tests::remote_file_hash"
    "--skip=filehash::tests::get_filehash_unit_test"
  ];

  meta = with lib; {
    description = "A Program to automatically decrypt and mount ZFS datasets using Yubikey HMAC as 2FA or any File on USB/SFTP/HTTPS.";
    homepage = "https://github.com/ashuio/shavee";
    license = licenses.mit;
    maintainers = with maintainers; [jasonodoom];
    platforms = platforms.linux;
  };
}
