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
  inherit (stdenv.hostPlatform) system;
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  lockfile = lib.importJSON ./lockfile.json;
  extInfo =
    (arch: {
      inherit arch;
      inherit (lockfile.${arch}) hash binaries;
    })
      (
        {
          x86_64-linux = "linux-x64";
          aarch64-linux = "linux-arm64";
          x86_64-darwin = "darwin-x64";
          aarch64-darwin = "darwin-arm64";
        }
        .${system} or (throw "Unsupported system: ${system}")
      );
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "csharp";
    publisher = "ms-dotnettools";
    inherit (lockfile) version;
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

    chmod +x ${lib.escapeShellArgs extInfo.binaries}
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
