{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pam,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "shavee";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "ashuio";
    repo = "shavee";
<<<<<<< HEAD
    rev = "shavee-v${version}";
    hash = "sha256-FxZXJ1cSq0rOiClDgJ1r+nv7aJSiTXyKChh/wFDKSxs=";
  };

  cargoHash = "sha256-eupHLZmMBLMMIL3x4KVmmKv1O9QKcU4zmn4ewOmUS8E=";
=======
    rev = "v${version}";
    hash = "sha256-41wJ3QBZdmCl7v/6JetXhzH2zF7tsKYMKZY1cKhByX8=";
  };

  cargoHash = "sha256-IGMEl/iK25WMkkLgbT7pCfppAf3GCvyBk1NrqMDtbUA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    pam
    zlib
  ];

<<<<<<< HEAD
  checkFlags = [
    # these tests require network access
    "--skip=filehash::tests::remote_file_hash"
    "--skip=filehash::tests::get_filehash_unit_test"
    # I think this test is broken?
    # errors with File PATH must be absolute eg. "/mnt/a/test.jpg", but provided path is relative
    "--skip=args::tests::input_args_check"
=======
  # these tests require network access
  checkFlags = [
    "--skip=filehash::tests::remote_file_hash"
    "--skip=filehash::tests::get_filehash_unit_test"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta = {
    homepage = "https://github.com/ashuio/shavee";
    description = "Program to automatically decrypt and mount ZFS datasets using Yubikey HMAC as 2FA or any File on USB/SFTP/HTTPS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jasonodoom ];
    platforms = lib.platforms.linux;
    mainProgram = "shavee";
  };
}
