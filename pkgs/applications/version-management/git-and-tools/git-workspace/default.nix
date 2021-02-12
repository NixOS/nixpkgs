{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, pkg-config, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-//EyGhuE8rMRL03TtECIi0X51/p/GvTqvr2FRQEIqFA=";
  };

  cargoSha256 = "sha256-7LVn/R9gnVvUg8C9r+6DVhxoCS1T0c7fF6zzPmEMfco=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ misuzu ];
  };
}
