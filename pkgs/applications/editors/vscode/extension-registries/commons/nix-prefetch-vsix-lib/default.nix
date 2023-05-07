{ lib
, stdenvNoCC
, shellcheck
, coreutils
, curl
, jq
, nix
, unzip
}:

stdenvNoCC.mkDerivation {
  pname = "nix-prefetch-vsix-lib";
  version = "0.1.0";

  preferLocalBuild = true;

  src = [
    ./nix-prefetch-vsix-lib.sh
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    substitute "$src" "$out/bin/$(stripHash "$src")" \
      --replace "###PLACEHOLDER_PATH_PREFIXING###" "PATH=\"${lib.makeBinPath [
        coreutils
        curl
        jq
        nix
        unzip
      ]}\''${PATH:+:}\''${PATH-}\"; export PATH"
    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckInputs = [
    shellcheck
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    # Run through shellcheck
    find "$out/bin" -mindepth 1 -type f,l -exec shellcheck --shell=bash "{}" \;

    # Test sourcing
    (
      set -eu -o pipefail
      source "$out/bin/nix-prefetch-vsix-lib.sh"
    )

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Bash library to construct a VSCode extension fetcher";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
