{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
    sha256 = "NKAp15mm/pH4g3+fPCxI6U8Y4qdAhV9CLkmII76oGrw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "trash-3.0.1" = "sha256-6GTdT7pVy9yVMeZglPUS4kub2xVLW1h1uynE6zX3w98=";
    };
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      completions/{cnc/cnc,conceal/conceal}.{bash,fish} \
      --zsh completions/{cnc/_cnc,conceal/_conceal}
  '';

  # There are no any tests in source project.
  doCheck = false;

  meta = with lib; {
    description = "A trash collector written in Rust";
    homepage = "https://github.com/TD-Sky/conceal";
    license = licenses.mit;
    maintainers = with maintainers; [ jedsek ];
  };
}
