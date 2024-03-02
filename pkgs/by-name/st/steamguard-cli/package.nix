{ installShellFiles
, lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "steamguard-cli";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LKzN4bNhouwOiTx3pEOLw3bDqRAhKkPi25i0yP/n0PI=";
  };

  cargoHash = "sha256-SLbT2538maN2gQAf8BdRHpDRcYjA9lkMgCpiEYOas28=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd steamguard \
      --bash <($out/bin/steamguard completion --shell bash) \
      --fish <($out/bin/steamguard completion --shell fish) \
      --zsh <($out/bin/steamguard completion --shell zsh) \
  '';

  meta = with lib; {
    changelog = "https://github.com/dyc3/steamguard-cli/releases/tag/v${version}";
    description = "A linux utility for generating 2FA codes for Steam and managing Steam trade confirmations.";
    homepage = "https://github.com/dyc3/steamguard-cli";
    license = with licenses; [ gpl3Only ];
    mainProgram = "steamguard";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
