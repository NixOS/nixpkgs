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
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N/KlxtxzEDwUvQMpgf2S6u7MaYiF0eXnMrGoowc08J0=";
  };

  cargoHash = "sha256-50EHc8ZHzbl5IFpi5k3/Katc3FaxBgnpf8COrpPHZWk=";

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
    maintainers = with maintainers; [
      jedsek
      kashw2
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
