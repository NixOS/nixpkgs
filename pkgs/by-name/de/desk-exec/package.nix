{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "desk-exec";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "AxerTheAxe";
    repo = "desk-exec";
    rev = "refs/tags/v${version}";
    hash = "sha256-bJLdd07IAf+ba++vtS0iSmeQSGygwSVNry2bHTDAgjE=";
  };

  cargoHash = "sha256-pK1WDtGkpPZgFwEm59TqoH7EkKPQivNuvsiOG0dbum4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    pushd target/${stdenv.hostPlatform.config}/release/dist
      installShellCompletion desk-exec.{bash,fish}
      installShellCompletion _desk-exec
      installManPage desk-exec.1
    popd
  '';

  meta = {
    description = "Execute programs defined in XDG desktop entries directly from the command line";
    homepage = "https://github.com/AxerTheAxe/desk-exec";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.axertheaxe ];
    mainProgram = "desk-exec";
    platforms = lib.platforms.linux;
  };
}
