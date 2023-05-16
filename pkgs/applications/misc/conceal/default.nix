<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, testers, conceal }:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.4.1";
=======
{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-zrG4AE8I1nVvEGNvi7tOsqn6yNOqpRmhJzbuJINnJBw=";
=======
    sha256 = "NKAp15mm/pH4g3+fPCxI6U8Y4qdAhV9CLkmII76oGrw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  # There are not any tests in source project.
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = conceal;
    command = "conceal --version";
    version = "conceal ${version}";
  };

=======
  # There are no any tests in source project.
  doCheck = false;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A trash collector written in Rust";
    homepage = "https://github.com/TD-Sky/conceal";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ jedsek kashw2 ];
=======
    maintainers = with maintainers; [ jedsek ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    broken = stdenv.isDarwin;
  };
}
