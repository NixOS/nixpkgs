{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  openssl,
  maa-assistant-arknights,
  android-tools,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "maa-cli";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "maa-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5qfA37es0wgVV8c8RqLrG4dtqc4T12w1OXf220h+eio=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ git ];

  # https://github.com/MaaAssistantArknights/maa-cli/pull/126
  buildNoDefaultFeatures = true;
  buildFeatures = [ "git2" ];

  cargoHash = "sha256-TQIW+1BiOcTSx9XjitE8nqPet2KKg2TMDbx0I5jasUw=";

  # maa-cli would only search libMaaCore.so and resources in itself's path
  # https://github.com/MaaAssistantArknights/maa-cli/issues/67
  postInstall = ''
    mkdir -p $out/share/maa-assistant-arknights/
    ln -s ${maa-assistant-arknights}/share/maa-assistant-arknights/* $out/share/maa-assistant-arknights/
    ln -s ${maa-assistant-arknights}/lib/* $out/share/maa-assistant-arknights/
    mv $out/bin/maa $out/share/maa-assistant-arknights/

    makeWrapper $out/share/maa-assistant-arknights/maa $out/bin/maa \
      --prefix PATH : "${
        lib.makeBinPath [
          android-tools
          git
        ]
      }"

  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd maa \
      --bash <($out/bin/maa complete bash) \
      --fish <($out/bin/maa complete fish) \
      --zsh <($out/bin/maa complete zsh)

    mkdir -p manpage
    $out/bin/maa mangen --path manpage
    installManPage manpage/*
  '';

  meta = {
    description = "Simple CLI for MAA by Rust";
    homepage = "https://github.com/MaaAssistantArknights/maa-cli";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      Cryolitia
      wangl-cc
    ];
    mainProgram = "maa";
  };
})
