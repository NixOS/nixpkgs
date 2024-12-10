{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  testers,
  conceal,
}:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zrG4AE8I1nVvEGNvi7tOsqn6yNOqpRmhJzbuJINnJBw=";
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

  # There are not any tests in source project.
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = conceal;
    command = "conceal --version";
    version = "conceal ${version}";
  };

  meta = with lib; {
    description = "A trash collector written in Rust";
    homepage = "https://github.com/TD-Sky/conceal";
    license = licenses.mit;
    maintainers = with maintainers; [
      jedsek
      kashw2
    ];
    broken = stdenv.isDarwin;
  };
}
