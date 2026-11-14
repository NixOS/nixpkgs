{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "0-unstable-2025-10-23";
  src = fetchFromGitHub {
    owner = "euclio";
    repo = "vim-markdown-composer";
    rev = "4f53f1c6e41c8fb916c50b50e18284d923f0f3cd";
    sha256 = "sha256-QODj8J2d2Qo8/B0rv5HthSidZcBgY11oNKwT8jCO6kI=";
  };

  vim-markdown-composer-bin = rustPlatform.buildRustPackage {
    pname = "vim-markdown-composer-bin";
    inherit src version;

    cargoHash = "sha256-/wkXbd4cEOEVhWW5KzMavay7a4XI1deonjn0QCP6z7I=";
    # tests require network access
    doCheck = false;
  };
in
vimUtils.buildVimPlugin {
  pname = "vim-markdown-composer";
  inherit version src;

  preFixup = ''
    substituteInPlace "$out"/after/ftplugin/markdown/composer.vim \
      --replace-fail \
      "s:plugin_root . '/target/release/markdown-composer'" \
      "'${vim-markdown-composer-bin}/bin/markdown-composer'"
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
      attrPath = "vimPlugins.vim-markdown-composer.vim-markdown-composer-bin";
    };

    # needed for the update script
    inherit vim-markdown-composer-bin;
  };

  meta = {
    description = "(Neo)vim plugin for asynchronous Markdown previews";
    homepage = "https://github.com/euclio/vim-markdown-composer/";
    # https://github.com/euclio/vim-markdown-composer/blob/4f53f1c6e41c8fb916c50b50e18284d923f0f3cd/doc/markdown-composer.txt#L4
    license = lib.licenses.mit;
  };
}
