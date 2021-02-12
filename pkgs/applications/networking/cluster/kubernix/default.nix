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

  cargoSha256 = "1czpw52v468vgyzcmvwmxaa9ffhy58pzibxs428kld8lvrb57nsp";
  doCheck = false;

  meta = with lib; {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
  };
}
