{ stdenv, lib, rustPlatform, fetchFromGitHub, installShellFiles, SystemConfiguration, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tNTKX++LrWwuVGdmAjvBStNYp4p1ai12JwJmozo1GV0=";
  };

  cargoSha256 = "sha256-t1d8K0v7kHPjH78lYCRCa4pyPCvyQT1kaQtVpoROZIE=";

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
