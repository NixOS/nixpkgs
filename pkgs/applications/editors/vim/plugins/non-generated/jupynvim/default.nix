{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "0.4.5";
  src = fetchFromGitHub {
    owner = "sheng-tse";
    repo = "jupynvim";
    tag = "v${version}";
    hash = "sha256-G8vyhsTfHtbE7foqj1HNJNMg3TYeO/Nd4ofRS+SVPUo=";
  };
  jupynvim-core = rustPlatform.buildRustPackage {
    pname = "jupynvim-core";
    inherit version src;

    sourceRoot = "${src.name}/core";

    cargoHash = "sha256-7zMuo7evZrer8CXAwbrZtLv/LdOuoZK95sMgyqs5P0I=";

    meta.mainProgram = "jupynvim-core";
  };
in
vimUtils.buildVimPlugin {
  pname = "jupynvim";
  inherit version src;

  # Upstream resolves the backend from an in-tree build directory that only
  # exists once its install hook has downloaded or built one.
  postInstall = ''
    rm -rf $out/core
    substituteInPlace $out/lua/jupynvim/backend/connect.lua \
      --replace-fail 'M._plugin_root() .. "/core/target/release/jupynvim-core"' \
                     '"${lib.getExe jupynvim-core}"'
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.jupynvim.jupynvim-core";
    };

    # needed for the update script
    inherit jupynvim-core;
  };

  meta = {
    description = "Jupyter notebooks in Neovim with native cell rendering and kernel execution";
    homepage = "https://github.com/sheng-tse/jupynvim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alikaansun ];
  };
}
