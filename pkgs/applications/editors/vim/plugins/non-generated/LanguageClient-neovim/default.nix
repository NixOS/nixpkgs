{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimUtils,
}:
let
  version = "0.1.161";
  src = fetchFromGitHub {
    owner = "autozimu";
    repo = "LanguageClient-neovim";
    tag = version;
    hash = "sha256-Z9S2ie9RxJCIbmjSV/Tto4lK04cZfWmK3IAy8YaySVI=";
  };
  LanguageClient-neovim-bin = rustPlatform.buildRustPackage {
    pname = "LanguageClient-neovim-bin";
    inherit version src;

    cargoHash = "sha256-H34UqJ6JOwuSABdOup5yKeIwFrGc83TUnw1ggJEx9o4=";
  };
in
vimUtils.buildVimPlugin {
  pname = "LanguageClient-neovim";
  inherit version src;

  propagatedBuildInputs = [ LanguageClient-neovim-bin ];

  preFixup = ''
    substituteInPlace "$out"/autoload/LanguageClient.vim \
      --replace-fail \
      "let l:path = s:root . '/bin/'" \
      "let l:path = '${LanguageClient-neovim-bin}' . '/bin/'"
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=(\\d+\\.\\d+\\.\\d+)" ];
      attrPath = "vimPlugins.LanguageClient-neovim.LanguageClient-neovim-bin";
    };

    # needed for the update script
    inherit LanguageClient-neovim-bin;
  };

  meta = {
    homepage = "https://github.com/autozimu/LanguageClient-neovim/";
    changelog = "https://github.com/autozimu/LanguageClient-neovim/releases/tag/${src.tag}";
    license = lib.licenses.mit;
  };
}
