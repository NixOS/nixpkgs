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
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BYLDSRgBba6SoGsL/NTV/OTG1/V9RSr8lisj42JqBRM=";
  };

  cargoHash = "sha256-loaKXnbhH6n6Bt58RQZdS/lxNguw+GIdB6uLcRZhVtg=";

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
