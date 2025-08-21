{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "artem";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "finefindus";
    repo = "artem";
    rev = "v${version}";
    hash = "sha256-C3Co+hXstVN/WADIpzqr7f3muAgQL0Zbnz6VI1XNo4U=";
  };

  cargoHash = "sha256-OPcT2iMZPx1mXXtghznq65YQtfxsOV1etgqZMMLzkmo=";

  nativeBuildInputs = [
    installShellFiles
  ];

  checkFlags = [
    # require internet access
    "--skip=arguments::input::url_input"
    "--skip=full_file_compare_url"

    # flaky
    "--skip=full_file_compare_html"
  ];

  postInstall = ''
    installManPage $releaseDir/build/artem-*/out/artem.1
    installShellCompletion $releaseDir/build/artem-*/out/artem.{bash,fish} \
      --zsh $releaseDir/build/artem-*/out/_artem
  '';

  meta = {
    description = "Small CLI program to convert images to ASCII art";
    homepage = "https://github.com/finefindus/artem";
    changelog = "https://github.com/finefindus/artem/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "artem";
  };
}
