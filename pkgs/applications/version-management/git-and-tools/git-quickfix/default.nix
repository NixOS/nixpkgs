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
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "siedentop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JdRlrNzWMPS3yG1UvKKtHVRix3buSm9jfSoAUxP35BY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
    libiconv
  ];

  cargoSha256 = "sha256-ENeHPhEBniR9L3J5el6QZrIS1Q4O0pNiSzJqP1aQS9Q=";

  meta = with lib; {
    description = "Quickfix allows you to commit changes in your git repository to a new branch without leaving the current branch";
    homepage = "https://github.com/siedentop/git-quickfix";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ msfjarvis ];
  };
}
