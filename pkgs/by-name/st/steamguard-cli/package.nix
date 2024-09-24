{ installShellFiles
, lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "steamguard-cli";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SrMg/4bTAvk+2fLck8SJBMQ3bELu1OBB7pDZmk+rCbA=";
  };

  cargoHash = "sha256-MSN0xQj6IfOjI0qQqVBaGhh0BQJa4z24El2rGLlFBSM=";

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
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
