{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "artem";
  version = "2.0.1_2";

  src = fetchFromGitHub {
    owner = "finefindus";
    repo = "artem";
    rev = "v${version}";
    hash = "sha256-R7ouOFeLKnTZI6NbAg8SkkSo4zh9AwPiMPNqhPthpCk=";
  };

  cargoHash = "sha256-sbIINbuIbu38NrYr87ljJJD7Y9Px0o6Qv/MGX8N54Rc=";

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

  # Cargo.lock is outdated
  postConfigure = ''
    cargo metadata --offline
  '';

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
