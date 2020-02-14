{ stdenv
, lib
, rustPlatform
, fetchpatch
, fetchFromGitHub
, pkg-config
, dbus
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "tiny";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "osa1";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m57xsrc7lzkrm8k1wh3yx3in5bhd0qjzygxdwr8lvigpsiy5caa";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1vj6whnx8gd5r66zric9163ddlqc4al4azj0dvhv5sq0r33871kv";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;
  buildInputs = lib.optionals stdenv.isLinux [ dbus openssl ];

  meta = with lib; {
    description = "A console IRC client";
    homepage = "https://github.com/osa1/tiny";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
