{ lib
, icu
, openssl
, patchelf
, stdenv
, vscode-utils
}:
let
  inherit (stdenv.hostPlatform) system;
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  extInfo = {
    x86_64-linux = {
      arch = "linux-x64";
      sha256 = "sha256-7m85Zl9oV40le3nkNPzoKu/AAf8XhQpI8sBMsQXmBg8=";
      binaries = [
        "components/vs-green-server/platforms/linux-x64/node_modules/@microsoft/servicehub-controller-net60.linux-x64/Microsoft.ServiceHub.Controller"
        "components/vs-green-server/platforms/linux-x64/node_modules/@microsoft/visualstudio-code-servicehost.linux-x64/Microsoft.VisualStudio.Code.ServiceHost"
        "components/vs-green-server/platforms/linux-x64/node_modules/@microsoft/visualstudio-reliability-monitor.linux-x64/Microsoft.VisualStudio.Reliability.Monitor"
        "components/vs-green-server/platforms/linux-x64/node_modules/@microsoft/visualstudio-server.linux-x64/Microsoft.VisualStudio.Code.Server"
      ];
    };
    aarch64-linux = {
      arch = "linux-arm64";
      sha256 = "sha256-39D55EdwE4baDYbHc9GD/1XoxGbQkUkS1H2uysJHlxw=";
      binaries = [
        "components/vs-green-server/platforms/linux-arm64/node_modules/@microsoft/servicehub-controller-net60.linux-arm64/Microsoft.ServiceHub.Controller"
        "components/vs-green-server/platforms/linux-arm64/node_modules/@microsoft/visualstudio-code-servicehost.linux-arm64/Microsoft.VisualStudio.Code.ServiceHost"
        "components/vs-green-server/platforms/linux-arm64/node_modules/@microsoft/visualstudio-reliability-monitor.linux-arm64/Microsoft.VisualStudio.Reliability.Monitor"
        "components/vs-green-server/platforms/linux-arm64/node_modules/@microsoft/visualstudio-server.linux-arm64/Microsoft.VisualStudio.Code.Server"
      ];
    };
    x86_64-darwin = {
      arch = "darwin-x64";
      sha256 = "sha256-gfhJX07R+DIw9FbzaEE0JZwEmDeifiq4vHyMHZZ1udM=";
      binaries = [
        "components/vs-green-server/platforms/darwin-x64/node_modules/@microsoft/servicehub-controller-net60.darwin-x64/Microsoft.ServiceHub.Controller"
        "components/vs-green-server/platforms/darwin-x64/node_modules/@microsoft/visualstudio-code-servicehost.darwin-x64/Microsoft.VisualStudio.Code.ServiceHost"
        "components/vs-green-server/platforms/darwin-x64/node_modules/@microsoft/visualstudio-reliability-monitor.darwin-x64/Microsoft.VisualStudio.Reliability.Monitor"
        "components/vs-green-server/platforms/darwin-x64/node_modules/@microsoft/visualstudio-server.darwin-x64/Microsoft.VisualStudio.Code.Server"
      ];
    };
    aarch64-darwin = {
      arch = "darwin-arm64";
      sha256 = "sha256-vogstgCWvI9csNF9JfJ41XPR1POy842g2yhWqIDoHLw=";
      binaries = [
        "components/vs-green-server/platforms/darwin-arm64/node_modules/@microsoft/servicehub-controller-net60.darwin-arm64/Microsoft.ServiceHub.Controller"
        "components/vs-green-server/platforms/darwin-arm64/node_modules/@microsoft/visualstudio-code-servicehost.darwin-arm64/Microsoft.VisualStudio.Code.ServiceHost"
        "components/vs-green-server/platforms/darwin-arm64/node_modules/@microsoft/visualstudio-reliability-monitor.darwin-arm64/Microsoft.VisualStudio.Reliability.Monitor"
        "components/vs-green-server/platforms/darwin-arm64/node_modules/@microsoft/visualstudio-server.darwin-arm64/Microsoft.VisualStudio.Code.Server"
      ];
    };
  }.${system} or (throw "Unsupported system: ${system}");
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "csdevkit";
    publisher = "ms-dotnettools";
    version = "1.4.28";
    inherit (extInfo) sha256 arch;
  };
  sourceRoot = "extension"; # This has more than one folder.

  nativeBuildInputs = [
    patchelf
  ];

  postPatch = ''
    declare ext_unique_id
    ext_unique_id="$(basename "$out" | head -c 32)"

    patchelf_add_icu_as_needed() {
      declare elf="''${1?}"
      declare icu_major_v="${
      lib.head (lib.splitVersion (lib.getVersion icu.name))
    }"

      for icu_lib in icui18n icuuc icudata; do
        patchelf --add-needed "lib''${icu_lib}.so.$icu_major_v" "$elf"
      done
    }

    patchelf_common() {
      declare elf="''${1?}"

      patchelf_add_icu_as_needed "$elf"
      patchelf --add-needed "libssl.so" "$elf"
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${lib.makeLibraryPath [stdenv.cc.cc openssl icu.out]}:\$ORIGIN" \
        "$elf"
    }

    substituteInPlace dist/extension.js \
      --replace 'e.extensionPath,"cache"' 'require("os").tmpdir(),"'"$ext_unique_id"'"' \
      --replace 't.setExecuteBit=async function(e){if("win32"!==process.platform){const t=i.join(e[a.SERVICEHUB_CONTROLLER_COMPONENT_NAME],"Microsoft.ServiceHub.Controller"),n=i.join(e[a.SERVICEHUB_HOST_COMPONENT_NAME],(0,a.getServiceHubHostEntrypointName)()),r=[(0,a.getServerPath)(e),t,n,(0,c.getReliabilityMonitorPath)(e)];await Promise.all(r.map((e=>(0,o.chmod)(e,"0755"))))}}' 't.setExecuteBit=async function(e){}'

  ''
  + (lib.concatStringsSep "\n" (map
    (bin: ''
      chmod +x "${bin}"
    '')
    extInfo.binaries))
  + lib.optionalString stdenv.isLinux (lib.concatStringsSep "\n" (map
    (bin: ''
      patchelf_common "${bin}"
    '')
    extInfo.binaries));

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/ms-dotnettools.csdevkit/changelog";
    description = "The official Visual Studio Code extension for C# from Microsoft";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.ggg ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
