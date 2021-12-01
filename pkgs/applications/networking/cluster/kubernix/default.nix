{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "kubernix";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = pname;
    rev = "v${version}";
    sha256 = "04dzfdzjwcwwaw9min322g30q0saxpq5kqzld4f22fmk820ki6gp";
  };

  cargoSha256 = "133h6mkz9aylhligy16pfjzsl94xxj0rk2zjm08dhg0inj84z3yv";
  doCheck = false;

  meta = with lib; {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
  };
}
