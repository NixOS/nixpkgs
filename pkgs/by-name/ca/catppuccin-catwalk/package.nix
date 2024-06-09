{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  libwebp,
}:
let
  version = "1.3.1";
in
rustPlatform.buildRustPackage {
  pname = "catppuccin-catwalk";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "toolbox";
    rev = "refs/tags/catwalk-v${version}";
    hash = "sha256-Mk4Kv1EfaDiqLUa+aOPeoM4jFlKoUau+VuqmnazRgGI=";
  };

  buildAndTestSubdir = "catwalk";
  cargoHash = "sha256-qxY8CUOl7fF4afJyFjGeOVk7GX/cewC/hAaJf6m5tfA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [ libwebp ];

  postInstall = ''
    installShellCompletion --cmd catwalk \
      --bash <("$out/bin/catwalk" completion bash) \
      --zsh <("$out/bin/catwalk" completion zsh) \
      --fish <("$out/bin/catwalk" completion fish)
  '';

  doInstallCheck = !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isElf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/bin/catwalk | grep -F 'Shared library: [libwebp.so'
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/catppuccin/toolbox/tree/main/catwalk";
    description = "A CLI for Catppuccin that takes in four showcase images and displays them all at once";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryanccn ];
    mainProgram = "catwalk";
  };
}
