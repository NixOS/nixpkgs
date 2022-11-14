{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "notmuch-mailmover";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "michaeladler";
    repo = pname;
    rev = "v${version}";
    sha256 = lib.fakeSha256;
  };

  cargoSha256 = lib.fakeSha256;

  meta = with lib; {
    description = "Application to assign notmuch tagged mails to IMAP folders";
    homepage = "https://github.com/michaeladler/notmuch-mailmover/";
    license = licenses.asl20;
    maintainers = with maintainers; [archer-65];
    platforms = platforms.all;
  };
}
