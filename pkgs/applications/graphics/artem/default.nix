{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "artem";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "finefindus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-liYZloaXN9doNyPO76iCaiZO9ZkNGBm+BxxNX87ZqBM=";
  };

  cargoHash = "sha256-fTAuh4jbfNpFaEu1X0LwVA30ghQ6mh5/Afap7gUjzMc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
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

  meta = with lib; {
    description = "A small CLI program to convert images to ASCII art";
    homepage = "https://github.com/finefindus/artem";
    changelog = "https://github.com/finefindus/artem/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
