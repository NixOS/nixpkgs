{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DzbbeVZifuxgmIu3yNv6EI7Jyh8MA0/oSaR5IEPNUN8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-B1sxbifMTnr6tLZCAuxVlQPL5oKCUL0wtw3/wOyfyyw=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libxcb ];

  postInstall = ''
    installManPage $releaseDir/../man/kmon.8
    installShellCompletion $releaseDir/../completions/kmon.{bash,fish} \
      --zsh $releaseDir/../completions/_kmon
  '';

  meta = with lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    changelog = "https://github.com/orhun/kmon/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
    mainProgram = "kmon";
  };
}
