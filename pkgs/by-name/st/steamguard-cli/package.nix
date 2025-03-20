{
  installShellFiles,
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "steamguard-cli";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = "steamguard-cli";
    rev = "v${version}";
    hash = "sha256-gPw0D5/XpT1bRYgG6GgDSP47Pa6MR3qzKhVwB4MrLKU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uu+Ngz5hfH1Pg2KcumpHW3BDggBGJgRh0W06a6fPrfg=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd steamguard \
      --bash <($out/bin/steamguard completion --shell bash) \
      --fish <($out/bin/steamguard completion --shell fish) \
      --zsh <($out/bin/steamguard completion --shell zsh) \
  '';

  meta = with lib; {
    changelog = "https://github.com/dyc3/steamguard-cli/releases/tag/v${version}";
    description = "Linux utility for generating 2FA codes for Steam and managing Steam trade confirmations";
    homepage = "https://github.com/dyc3/steamguard-cli";
    license = with licenses; [ gpl3Only ];
    mainProgram = "steamguard";
    maintainers = with maintainers; [
      surfaceflinger
      sigmasquadron
    ];
    platforms = platforms.linux;
  };
}
