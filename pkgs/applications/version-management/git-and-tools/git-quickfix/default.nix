{ lib, fetchFromGitHub
, libiconv
, openssl
, pkg-config
, rustPlatform
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-quickfix";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "siedentop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LDA94pH5Oodf80mEENoURh+MJSg122SVWFVo9i1TEQg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
    libiconv
  ];

  cargoSha256 = "sha256-QTPy0w45AawEU4fHf2FMGpL3YM+iTNnyiI4+mDJzWaE=";

  meta = with lib; {
    description = "Quickfix allows you to commit changes in your git repository to a new branch without leaving the current branch";
    homepage = "https://github.com/siedentop/git-quickfix";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ msfjarvis ];
  };
}
