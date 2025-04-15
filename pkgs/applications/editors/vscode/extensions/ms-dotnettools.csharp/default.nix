{
  lib,
  stdenv,
  vscode-utils,
  autoPatchelfHook,
  icu,
  openssl,
  libz,
  glibc,
  coreutils,
}:
let
  extInfo = (
    {
      x86_64-linux = {
        arch = "linux-x64";
        hash = "sha256-YmlXnmLp0ZtFvHXOsI0sLySLprU+ntduywvvlZ2Riw0=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-QBon9zOXykngvJHydJQPdgjvLxy65DbWS+IUAzo638o=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-fOfCm+XiD5NVexMlBeBfSxtTr9mTnn2HKFsJjuGBCJ0=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-e1cxz8A2IlO6fnN41PKXqPxthTuAOmAWy6/kRck6hsM=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
  );
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "csharp";
    publisher = "ms-dotnettools";
    version = "2.72.27";
    inherit (extInfo) hash arch;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc) # libstdc++.so.6
    (lib.getLib glibc) # libgcc_s.so.1
    (lib.getLib libz) # libz.so.1
  ];
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib openssl) # libopenssl.so.3
    (lib.getLib icu) # libicui18n.so libicuuc.so
    (lib.getLib libz) # libz.so.1
  ];

  postPatch = ''
    substituteInPlace dist/extension.js \
      --replace-fail 'uname -m' '${lib.getExe' coreutils "uname"} -m'
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
    description = "Official C# support for Visual Studio Code";
    homepage = "https://github.com/dotnet/vscode-csharp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ggg ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
