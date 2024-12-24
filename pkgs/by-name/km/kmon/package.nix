{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+pzVSCmK4Ex0CA94PtP2A+tW4p88THQlkhEhdOA4jdg=";
  };

  cargoHash = "sha256-s7/WuV4tTA06yRcvJMrEFXcemy/9ia5ZVRS5LDj/oXY=";

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
