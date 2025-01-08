{
  installShellFiles,
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "steamguard-cli";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Cxl6FczWr5kAYt+q1m3HLEKCBeQz3TcW/aaOxsBcuwc=";
  };

  cargoHash = "sha256-YKlTEKk2pbwLIFZjK/sBIIYwu0DYarVeJsIB9FSR9XM=";

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
