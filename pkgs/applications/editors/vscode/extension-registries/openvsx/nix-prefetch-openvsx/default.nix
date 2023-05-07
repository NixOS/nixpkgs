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
  pname = "nix-prefetch-openvsx";
  version = "0.1.0";

  preferLocalBuild = true;

  src = ./nix-prefetch-openvsx;

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    bash
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    install -m 755 -T "$src" "$out/bin/nix-prefetch-openvsx"
    patchShebangs --host "$out/bin/nix-prefetch-openvsx"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/nix-prefetch-openvsx" \
      --prefix PATH : "${lib.makeBinPath [
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
    description = "Prefetch vscode extensions from Open VSX Registry";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
