<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, oniguruma
, stdenv
, darwin
=======
{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, DiskArbitration
, Foundation
, libiconv
, Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "delta";
<<<<<<< HEAD
  version = "0.16.5";
=======
  version = "0.15.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-W6XtfXfOP8QfQ0t5hquFdYvCO9muE50N1fQsNtnOzfM=";
  };

  cargoHash = "sha256-SNKbgEyelJCHKCaBRfCGc3RECGABtZzMC2rCbhzqZtU=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Foundation
  ];

  nativeCheckInputs = [ git ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    installShellCompletion --cmd delta \
      etc/completion/completion.{bash,fish,zsh}
=======
    sha256 = "sha256-rPtLvO6raBY6BfrP0erBaXD86W1JL8g4XC4VbkR4Pww=";
  };

  cargoSha256 = "sha256-raT8a8K05ZpiGuZdM1hNikGxqY6w0g8G1DohfybXD9s=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation libiconv Security ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    installShellCompletion --bash --name delta.bash etc/completion/completion.bash
    installShellCompletion --zsh --name _delta etc/completion/completion.zsh
    installShellCompletion --fish --name delta.fish etc/completion/completion.fish
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  checkFlags = lib.optionals stdenv.isDarwin [
    "--skip=test_diff_same_non_empty_file"
  ];

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ marsam zowoq SuperSandro2000 figsoda ];
=======
    maintainers = with maintainers; [ marsam zowoq SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
