{
  lib,
  stdenv,
  vscode-utils,
  autoPatchelfHook,
  icu,
  openssl,
  libz,
  glibc,
  libxml2,
}:
let
  extInfo = (
    {
      x86_64-linux = {
        arch = "linux-x64";
        hash = "sha256-5B2LAV5azD1mGDFWnxIOYjyyJMXxqxyL5qP0zs6jWgs=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-6tmHa8XbuNLheUzY8pr6oEJlkUJpeCeT3O7xfo2Iqls=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-KRJ148+N3Hzht1GgnO0s5Mv27q+onPyZlY9myXw3zjg=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-vmtE6oeLs1B9s69yaOHASdFKznV1p3v+SsJUAJrwUrU=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
  );
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "csdevkit";
    publisher = "ms-dotnettools";
    version = "1.18.23";
    inherit (extInfo) hash arch;
  };
  sourceRoot = "extension"; # This has more than one folder.

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc) # libstdc++.so.6
    (lib.getLib glibc) # libgcc_s.so.1
    (lib.getLib libxml2) # libxml2.so.2
  ];
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib openssl) # libopenssl.so.3
    (lib.getLib icu) # libicui18n.so libicuuc.so
    (lib.getLib libz) # libz.so.1
  ];

  postPatch = ''
    declare ext_unique_id
    ext_unique_id="$(basename "$out" | head -c 32)"

    substituteInPlace dist/extension.js \
      --replace-fail 'e.extensionPath,"cache"' 'require("os").tmpdir(),"'"$ext_unique_id"'"' \
      --replace-fail 't.setExecuteBit=async function(e){if("win32"!==process.platform){const t=i.join(e[a.SERVICEHUB_CONTROLLER_COMPONENT_NAME],"Microsoft.VisualStudio.Code.ServiceController"),r=i.join(e[a.SERVICEHUB_HOST_COMPONENT_NAME],(0,a.getServiceHubHostEntrypointName)()),n=[(0,a.getServerPath)(e),t,r,(0,c.getReliabilityMonitorPath)(e)];await Promise.all(n.map((e=>(0,o.chmod)(e,"0755"))))}}' 't.setExecuteBit=async function(e){}'
  '';

  preFixup = ''
    (
      shopt -s globstar
      shopt -s dotglob
      for file in "$out"/**/*; do
        if [[ ! -f "$file" || "$file" == *.so || "$file" == *.dylib ]] ||
            (! isELF "$file" && ! isMachO "$file"); then
            continue
        fi

        echo Making "$file" executable...
        chmod +x "$file"
      done
    )
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/ms-dotnettools.csdevkit/changelog";
    description = "Official Visual Studio Code extension for C# from Microsoft";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ggg ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
