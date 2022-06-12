{ stdenv, lib, rustPlatform, fetchFromGitHub, installShellFiles, SystemConfiguration, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eFO9v+CZ3sFJJ0Ksa2sV5snjBz9lUkElGSj4DfEUebs=";
  };

  cargoSha256 = "sha256-cyuDXMmVrVx3kluumR6WleMzuoV+261f47rpkVYHzZA=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration libiconv ];

  checkFlags = [ "--skip=test_single_huge_payload" "--skip=test_create_unix_socket" ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/pueue completions $shell .
    done
    installShellCompletion pueue.{bash,fish} _pueue
  '';

  meta = with lib; {
    description = "A daemon for managing long running shell commands";
    homepage = "https://github.com/Nukesor/pueue";
    changelog = "https://github.com/Nukesor/pueue/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
