{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "neocmakelsp";
  version = "0.8.15";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "neocmakelsp";
    rev = "v${version}";
    hash = "sha256-TCzW8QPSCGufLQanwcvgA5YsTV/QqDs7NKgOMPOgGho=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tuXeVgmYRfzEf3chWz9ovqkzpq5qaERyNibAmzqdJVo=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --bash completions/bash/neocmakelsp
    installShellCompletion --fish completions/fish/neocmakelsp.fish
    installShellCompletion --zsh completions/zsh/_neocmakelsp
  '';

  meta = {
    description = "CMake lsp based on tower-lsp and treesitter";
    homepage = "https://github.com/Decodetalkers/neocmakelsp";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      rewine
      multivac61
    ];
    mainProgram = "neocmakelsp";
  };
}
