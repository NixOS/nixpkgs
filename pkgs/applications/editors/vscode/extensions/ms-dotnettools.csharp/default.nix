{
  lib,
  stdenv,
  vscode-utils,
  autoPatchelfHook,
  icu,
  openssl,
  libz,
  glibc,
  libkrb5,
  coreutils,
  jq,
  patchelf,
}:
let
  extInfo = (
    {
      x86_64-linux = {
        arch = "linux-x64";
        hash = "sha256-rxXyDIDANtWUT4z6SK+fHwMXu/xSOIGtNpILdlC5lMc=";
      };
      aarch64-linux = {
        arch = "linux-arm64";
        hash = "sha256-3JLnZr7pGOY0wSmo9PpQclDE/Yb99qJLALgEBAPn4Ms=";
      };
      x86_64-darwin = {
        arch = "darwin-x64";
        hash = "sha256-yhP5dXP42ZKsoLZ3CySY+Nw2c0bF4IKDc0Le9ky+Qmc=";
      };
      aarch64-darwin = {
        arch = "darwin-arm64";
        hash = "sha256-KtOZ4AzsS30nF0DtJJT/CaLRD6Pa9pz1hYBgvxPbzZw=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
  );
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "csharp";
    publisher = "ms-dotnettools";
    version = "2.80.16";
    inherit (extInfo) hash arch;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    jq
    patchelf
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib glibc) # libgcc_s.so.1
    (lib.getLib icu) # libicui18n.so libicuuc.so
    (lib.getLib libkrb5) # libgssapi_krb5.so
    (lib.getLib libz) # libz.so.1
    (lib.getLib openssl) # libopenssl.so.3
    (lib.getLib stdenv.cc.cc) # libstdc++.so.6
  ];

  postPatch = ''
    substituteInPlace dist/extension.js \
      --replace-fail 'uname -m' '${lib.getExe' coreutils "uname"} -m'
  '';

  preFixup = ''
    (
      set -euo pipefail
      shopt -s globstar
      shopt -s dotglob

      # Fix all binaries.
      for file in "$out"/**/*; do
        if [[ ! -f "$file" || "$file" == *.so || "$file" == *.a || "$file" == *.dylib ]] ||
            (! isELF "$file" && ! isMachO "$file"); then
            continue
        fi

        echo Making "$file" executable...
        chmod +x "$file"

        ${lib.optionalString stdenv.hostPlatform.isLinux ''
          # Add .NET deps if it is an apphost.
          if grep 'You must install .NET to run this application.' "$file" > /dev/null; then
            echo "Adding .NET needed libraries to: $file"
            patchelf \
              --add-needed libicui18n.so \
              --add-needed libicuuc.so \
              --add-needed libgssapi_krb5.so \
              --add-needed libssl.so \
              "$file"
          fi
        ''}
      done

      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        # Add the ICU libraries as needed to the globalization DLLs.
        for file in "$out"/**/{libcoreclr.so,*System.Globalization.Native.so}; do
          echo "Adding ICU libraries to: $file"
          patchelf \
            --add-needed libicui18n.so \
            --add-needed libicuuc.so \
            "$file"
        done

        # Add the Kerberos libraries as needed to the native security DLL.
        for file in "$out"/**/*System.Net.Security.Native.so; do
          echo "Adding Kerberos libraries to: $file"
          patchelf \
            --add-needed libgssapi_krb5.so \
            "$file"
        done

        # Add the OpenSSL libraries as needed to the OpenSSL native security DLL.
        for file in "$out"/**/*System.Security.Cryptography.Native.OpenSsl.so; do
          echo "Adding OpenSSL libraries to: $file"
          patchelf \
            --add-needed libssl.so \
            "$file"
        done

        # Add the needed binaries to the apphost binaries.
        for file in $(jq -r '.runtimeDependencies | map(select(.binaries != null) | .installPath + "/" + .binaries[]) | sort | unique | map(sub("/\\./"; "/")) | .[]' < "$out"/share/vscode/extensions/ms-dotnettools.csharp/package.json); do
          [ -f "$out"/share/vscode/extensions/ms-dotnettools.csharp/"$file" ] || continue

          echo "Adding .NET needed libraries to: $out/share/vscode/extensions/ms-dotnettools.csharp/$file"
          patchelf \
            --add-needed libicui18n.so \
            --add-needed libicuuc.so \
            --add-needed libgssapi_krb5.so \
            --add-needed libssl.so \
            "$out"/share/vscode/extensions/ms-dotnettools.csharp/"$file"
        done
      ''}
    )
  '';

  meta = {
    description = "Official C# support for Visual Studio Code";
    homepage = "https://github.com/dotnet/vscode-csharp";
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
