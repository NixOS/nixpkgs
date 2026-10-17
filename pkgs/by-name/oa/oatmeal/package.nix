{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, makeRustPlatform
, installShellFiles
}:
let
  version = "0.12.3";

  oatmeal = fetchFromGitHub {
    name = "oatmeal";
    owner = "dustinblackman";
    repo = "oatmeal";
    rev = "v${version}";
    hash = "sha256-le9yLZVBqnw4vvOBVLsb0XrmXqs1iQ1duCmLKtYAA7s=";
  };

  arrayToSrc = arr: lib.forEach arr (e:
    fetchFromGitHub {
      inherit (e) rev repo owner;
      hash = e.nix-hash;
      name = e.repo;
    }
  );

  assets = lib.importTOML (oatmeal + "/assets.toml");
  syntaxes = arrayToSrc assets.syntaxes;
  themes = arrayToSrc assets.themes;

  allSyntaxDirs = lib.concatStringsSep " " (lib.forEach syntaxes (e: "${e}"));
  allThemeDirs = lib.concatStringsSep " " (lib.forEach themes (e: "${e}"));

in
rustPlatform.buildRustPackage {
  pname = "oatmeal";
  inherit version;
  srcs = [ oatmeal ] ++ syntaxes ++ themes;
  sourceRoot = oatmeal.name;

  cargoLock.lockFile = oatmeal + "/Cargo.lock";

  env = {
    VERGEN_IDEMPOTENT = 1;
  };

  nativeBuildInputs = [ installShellFiles ];

  preConfigure = ''
    # Copy in assets
    export OATMEAL_BUILD_DOWNLOADED_THEMES_DIR="$(mktemp -d)"
    export OATMEAL_BUILD_DOWNLOADED_SYNTAXES_DIR="$(mktemp -d)"
    export OATMEAL_LOG_DIR="$(mktemp -d)"
    cp -r ${allSyntaxDirs} $OATMEAL_BUILD_DOWNLOADED_SYNTAXES_DIR
    cp -r ${allThemeDirs} $OATMEAL_BUILD_DOWNLOADED_THEMES_DIR
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform.canExecute stdenv.buildPlatform) ''
    $out/bin/oatmeal manpages 1>oatmeal.1
    installManPage oatmeal.1

    installShellCompletion --cmd oatmeal \
      --bash <($out/bin/oatmeal completions -s bash) \
      --fish <($out/bin/oatmeal completions -s fish) \
      --zsh <($out/bin/oatmeal completions -s zsh)
  '';

  meta = {
    description = "Terminal UI to chat with large language models (LLM)";
    longDescription = ''
      Oatmeal is a terminal UI chat application that speaks with LLMs, complete with
      slash commands and fancy chat bubbles. It features agnostic backends to allow
      switching between the powerhouse of ChatGPT, or keeping things private with
      Ollama. While Oatmeal works great as a stand alone terminal application, it
      works even better paired with an editor like Neovim!
    '';
    homepage = "https://github.com/dustinblackman/oatmeal/";
    changelog = "https://github.com/dustinblackman/oatmeal/blob/main/CHANGELOG.md";
    downloadPage = "https://github.com/dustinblackman/oatmeal/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dustinblackman ];
    mainProgram = "oatmeal";
  };
}
