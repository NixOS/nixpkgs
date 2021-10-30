{ fetchFromGitHub, lib, rustPlatform, stdenv, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = version;
    sha256 = "sha256-+qKOvFoEF/gZL4ijL8lIRWE9ZWJM2eBlk29Lk46jAfQ=";
  };

  # upstream includes an outdated Cargo.lock that stops cargo from compiling
  cargoPatches = [ ./fix-cargo-lock.patch ];

  cargoSha256 = "sha256-JlekxU9pMkHNsIcH3+7b2I6MYUlxRqNX+0wwyVrQMAE=";

  buildInputs = lib.optional stdenv.isDarwin SystemConfiguration;

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
