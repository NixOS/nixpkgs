{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
<<<<<<< HEAD
, stdenv
, darwin
=======
, pkg-config
, openssl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "artem";
<<<<<<< HEAD
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "finefindus";
    repo = "artem";
    rev = "v${version}";
    hash = "sha256-t8L1lylaacEHGg3wxVgiB2XmBHDGzql774oHrg/vUC0=";
  };

  cargoHash = "sha256-rsgl8g6AqNmdq2gJ3PHvKMb7eid8ewtheajGWSWbeBw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];
=======
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "finefindus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wd8csdt7qOWFhUBRjqfJSEGnNDyHD7lJA8CtW+q4Kxg=";
  };

  cargoSha256 = "sha256-zFXQUQVPqTur7m+aL0JhSiZI+EEFo9nCTVu1yAOgp/I=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
