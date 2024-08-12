{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, testers, conceal }:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LPuPpcs0PtZk516wM9cfhvV12550VBQugVvbQBWxnxA=";
  };

  cargoHash = "sha256-7FUUte6hAY+KyD9t3rgibkhARFcWIIrFyX4vWSAwcBU=";

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
    description = "Trash collector written in Rust";
    homepage = "https://github.com/TD-Sky/conceal";
    license = licenses.mit;
    maintainers = with maintainers; [ jedsek kashw2 ];
    broken = stdenv.isDarwin;
  };
}
