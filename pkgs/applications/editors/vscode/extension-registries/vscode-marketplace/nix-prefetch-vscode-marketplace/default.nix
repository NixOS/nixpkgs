{ stdenvNoCC
, lib
, makeWrapper
, shellcheck
, bash
, coreutils
, curl
, jq
, unzip
, nix
, nix-prefetch-vsix-lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "nix-prefetch-vscode-marketplace";
  version = "0.1.0";

  preferLocalBuild = true;

  src = ./nix-prefetch-vscode-marketplace;

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    bash
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp "$src" "$out/bin/nix-prefetch-vscode-marketplace"
    chmod +x "$out/bin/nix-prefetch-vscode-marketplace"
    patchShebangs --host "$out/bin/nix-prefetch-vscode-marketplace"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/nix-prefetch-vscode-marketplace" \
      --prefix PATH : "${lib.makeBinPath [
        coreutils
        curl
        jq
        unzip
        nix
        nix-prefetch-vsix-lib
      ]}"
  '';

  doInstallCheck = true;

  installCheckInputs = [
    shellcheck
    nix-prefetch-vsix-lib
  ];

  installCheckPhase = ''
    runHook preInstallCheck
    find "$out/bin" -mindepth 1 -type f,l -exec shellcheck -x -P "$PATH" "{}" \;
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Prefetch vscode extensions from the official marketplace";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
