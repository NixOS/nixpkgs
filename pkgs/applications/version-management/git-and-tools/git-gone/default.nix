{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = "git-gone";
    rev = "v${version}";
    sha256 = "sha256-pHtFLJGZYlxvQxqG/LWoWeQDxa8i3ws0olAtuoyHXTM=";
  };

  cargoSha256 = "sha256-BfUR/9WBgyUlKZ80qtqX6+AK7hRBCCsEG/IWjbcDU3c=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage git-gone.1
  '';

  meta = with lib; {
    description = "Cleanup stale Git branches of merge requests";
    homepage = "https://github.com/lunaryorn/git-gone";
    changelog = "https://github.com/lunaryorn/git-gone/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
