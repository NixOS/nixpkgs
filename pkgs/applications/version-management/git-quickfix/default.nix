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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "siedentop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IAjet/bDG/Hf/whS+yrEQSquj8s5DEmFis+5ysLLuxs=";
  };

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Security
    SystemConfiguration
    libiconv
  ];

  cargoHash = "sha256-eTAEf2nRrJ7i2Dw5BBZlLLu8mK2G/wUk40ivtfxk1pI=";

  meta = with lib; {
    description = "Quickfix allows you to commit changes in your git repository to a new branch without leaving the current branch";
    homepage = "https://github.com/siedentop/git-quickfix";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "git-quickfix";
  };
}
