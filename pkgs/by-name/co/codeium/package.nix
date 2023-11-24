{ stdenv, lib, fetchurl, gzip, autoPatchelfHook }:
let

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux_x64";
    aarch64-linux = "linux_arm";
    x86_64-darwin = "macos_x64";
    aarch64-darwin = "macos_arm";

  }.${system} or throwSystem;

  hash = {
    x86_64-linux = "sha256-6dbgmYyXOUuWGOFXcO9eEZVoRjRLWK906SJh27wZ+PY=";
    aarch64-linux = "sha256-cO1+ZVXC25zO5msU6Nbp29vkkNFRQ2jKSxtCZw1H104=";
    x86_64-darwin = "sha256-3KMSoFQz7kYinD4QbS82dIq6UDetfdky6ClIfP83ISg=";
    aarch64-darwin = "sha256-bj8PVJ4pfrNXo1yn5UbkHflskZMS61+LM9hi9mtdXtk=";
  }.${system} or throwSystem;

  bin = "$out/bin/codeium_language_server";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "codeium";
  version = "1.4.16";
  src = fetchurl {
    name = "${finalAttrs.pname}-${finalAttrs.version}.gz";
    url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${finalAttrs.version}/language_server_${plat}.gz";
    inherit hash;
  };

  nativeBuildInputs = [ gzip ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    gzip -dc $src > ${bin}
    chmod +x ${bin}
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = rec {
    description = "Codeium language server";
    longDescription = ''
      Codeium proprietary language server, patched for Nix(OS) compatibility.
      bin/language_server_x must be symlinked into the plugin directory, replacing the existing binary.
      For example:
      ```shell
      ln -s "$(which codeium_language_server)" /home/a/.local/share/JetBrains/Rider2023.1/codeium/662505c9b23342478d971f66a530cd102ae35df7/language_server_linux_x64
      ```
    '';
    homepage = "https://codeium.com/";
    downloadPage = homepage;
    changelog = homepage;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ anpin ];
    mainProgram = "codeium";
    platforms = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" "x86_64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
