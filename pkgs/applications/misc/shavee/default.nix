{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pam
, pkg-config
, openssl
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "shavee";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ashuio";
    repo = "shavee";
    rev = "v${version}";
    hash = "sha256-41wJ3QBZdmCl7v/6JetXhzH2zF7tsKYMKZY1cKhByX8=";
  };

  cargoHash = "sha256-iNGn5KknSNgazFSu6Nur7AkKVb6qKMxuFwTdCz5djWU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    pam
    zlib
  ];

   # these tests require network access
  checkFlags = [
    "--skip=filehash::tests::remote_file_hash"
    "--skip=filehash::tests::get_filehash_unit_test"
  ];

  meta = {
    homepage = "https://github.com/ashuio/shavee";
    description = "A program to automatically decrypt and mount ZFS datasets using Yubikey HMAC as 2FA or any File on USB/SFTP/HTTPS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jasonodoom ];
    platforms = lib.platforms.linux;
  };
}
