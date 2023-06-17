{ notmuch
, lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "notmuch-mailmover";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "michaeladler";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b2Q1JcXIp56Niv5kdPgQSM91e8hPPdyhWIG4f7kQn78=";
  };

  buildInputs = [ notmuch ];

  cargoSha256 = "sha256-AW0mCdQN3WJhSErJ/MqnNIsRX+C6Pb/zHCQh7v/70MU=";

  meta = with lib; {
    description = "Application to assign notmuch tagged mails to IMAP folders";
    homepage = "https://github.com/michaeladler/notmuch-mailmover/";
    license = licenses.asl20;
    maintainers = with maintainers; [ michaeladler archer-65 ];
    platforms = platforms.all;
  };
}
