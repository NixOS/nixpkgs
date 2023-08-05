{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "leetup";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dragfire";
    repo = "leetup";
    rev = "v${version}";
    hash = "sha256-qqN5fWyxt5zMdv0oMLNicnjccn2lHsrkamxQZj4JA/g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # this test require network access
  checkFlags = [
    "--skip=tests::pick_problem_lang_rust"
  ];

  meta = with lib; {
    description = "Command line tool to solve Leetcode problems";
    homepage = "https://github.com/dragfire/leetup";
    license = licenses.mit;
    maintainers = with maintainers; [ xrelkd ];
  };
}
