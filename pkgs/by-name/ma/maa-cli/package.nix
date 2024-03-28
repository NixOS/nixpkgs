{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, makeWrapper
, pkg-config
, openssl
, maa-assistant-arknights
, android-tools
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "maa-cli";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "maa-cli";
    rev = "v${version}";
    hash = "sha256-pAtv6gCLFKRwUQEF6kD2bCPGpQGzahsfq/tAnQjrZrw=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # https://github.com/MaaAssistantArknights/maa-cli/pull/126
  buildNoDefaultFeatures = true;
  buildFeatures = [ "git2" "core_installer" ];

  cargoHash = "sha256-KjI/5vl7oKVtXYehGLgi9jcaO4Y/TceL498rCPGHMD0=";

  # maa-cli would only seach libMaaCore.so and resources in itself's path
  # https://github.com/MaaAssistantArknights/maa-cli/issues/67
  postInstall = ''
    mkdir -p $out/share/maa-assistant-arknights/
    ln -s ${maa-assistant-arknights}/share/maa-assistant-arknights/* $out/share/maa-assistant-arknights/
    ln -s ${maa-assistant-arknights}/lib/* $out/share/maa-assistant-arknights/
    mv $out/bin/maa $out/share/maa-assistant-arknights/

    makeWrapper $out/share/maa-assistant-arknights/maa $out/bin/maa \
      --prefix PATH : "${lib.makeBinPath [
        android-tools git
      ]}"

    installShellCompletion --cmd maa \
      --bash <($out/bin/maa complete bash) \
      --fish <($out/bin/maa complete fish) \
      --zsh <($out/bin/maa complete zsh)
  '';

  meta = with lib; {
    description = "A simple CLI for MAA by Rust";
    homepage = "https://github.com/MaaAssistantArknights/maa-cli";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Cryolitia ];
    mainProgram = "maa";
  };
}
