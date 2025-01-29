{
  applyPatches,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "simple-completion-language-server";
  version = "0-unstable-2025-01-28";

  # We need to use `applyPatches` here since our patch modifies the `Cargo.lock` file.
  # `cargoHash` seems to use `src` directly without applying `patches`.
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "estin";
      repo = "simple-completion-language-server";
      rev = "7bdf05bbf2c72d2b083c04c025de9c2af5bf1d78";
      hash = "sha256-SNhn4J3EPFsyjh97OmXHJmq6FmDWZLXOWZDi8Sway+A=";
    };
    patches = [
      # Ideally we would fetch this patch from GitHub directly, but I needed to
      # modify it to only include the changes for src/main.rs.
      #
      # ref; https://github.com/zed-industries/simple-completion-language-server/commit/3c098ca0715c0f037240e97cf3a77bef788a36cc
      ./3c098ca0715c0f037240e97cf3a77bef788a36cc.patch
    ];
  };

  cargoHash = "sha256-ziVmO86modj1pQmwAp1HfFqnF4j2V+sJNwu2o3v/oZ8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = {
    mainProgram = "simple-completion-language-server";
    description = "Language server to enable word completion and snippets";
    homepage = "https://github.com/zed-industries/simple-completion-language-server/";
    maintainers = with lib.maintainers; [ matthewpi ];
    license = lib.licenses.mit;
  };
}
