{
  lib,
  rustPlatform,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  nix-update-script,
  writeText,
}:

let
  stubsSrc = fetchFromGitHub {
    owner = "JetBrains";
    repo = "phpstorm-stubs";
    rev = "3327932472f512d2eb9e122b19702b335083fd9d";
    hash = "sha256-WN5DAvaw4FfHBl2AqSo1OcEthUm3lOpikdB78qy3cyY=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phpantom-lsp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "AJenbo";
    repo = "phpantom_lsp";
    tag = finalAttrs.version;
    hash = "sha256-0hhIlAOxBRmiyuvKS8nYWcarOXkOI1VRFqbSs/b4sGw=";
  };

  postPatch = ''
    mkdir -p stubs/jetbrains
    cp -a ${stubsSrc} stubs/jetbrains/phpstorm-stubs
    chmod u+wx stubs/jetbrains/phpstorm-stubs

    echo "${stubsSrc.rev}" \
      > stubs/jetbrains/phpstorm-stubs/.commit
  '';

  cargoHash = "sha256-oRjXf1zR0Ajot6l6ljNAfT7o9yi8m9v8Iwc2xBlTxHM=";

  checkFlags = [
    "--test"
    "completion_inheritance"
  ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (writeText "update-php-stubs.sh" ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i bash -p bash curl gnused gnugrep nix-prefetch-git jq

      file="${./package.nix}"

      version="$(grep -oP 'version = "\K[\d\.]+' "$file")"
      curl -O "https://raw.githubusercontent.com/AJenbo/phpantom_lsp/refs/tags/$version/stubs.lock"
      stubsVersion="$(grep -oP 'commit = "\K[^"]+' ./stubs.lock)"
      rm stubs.lock

      stubsHash="$(
        nix-prefetch-git --rev "$stubsVersion" "https://github.com/JetBrains/phpstorm-stubs.git" \
          2> /dev/null \
          | jq -r '.hash'
      )"

      sed -i 's/\(rev = "\)[^"]*/\1'"$stubsVersion"'/' "$file"
      sed -i '/stubsSrc/,/}/ s/\(hash = "\)[^"]*/\1'"$stubsHash"'/'
    '')
  ];

  meta = {
    changelog = "https://github.com/AJenbo/phpantom_lsp/releases/tag/${finalAttrs.version}";
    description = "Fast, lightweight PHP language server written in Rust";
    homepage = "https://github.com/AJenbo/phpantom_lsp";
    license = lib.licenses.mit;
    mainProgram = "phpantom_lsp";
    maintainers = with lib.maintainers; [ nanoyaki ];
    platforms = lib.platforms.darwin ++ [
      "aarch64-linux"
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
})
