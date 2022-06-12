{ lib, rustPlatform, fetchFromGitHub, stdenv, SystemConfiguration, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = version;
    sha256 = "sha256-RbA7MM/3u2LJG6QD5f15E/XoLwHMkPasx0ht4PqV/jc=";
  };

  cargoSha256 = "sha256-vhTfAoAwDJ9BjhgUEkV2H+KAetJR1YqwaZ7suF6yMXA=";

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration Foundation ];

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
