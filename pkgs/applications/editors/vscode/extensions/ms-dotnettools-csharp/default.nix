{ lib
, fetchurl
, vscode-utils
, patchelf
, icu
, stdenv
, openssl
}:
let
  inherit (stdenv.hostPlatform) system;

  version = "1.25.0";


  vsixInfo =
    let
      linuxDebuggerBins = [
        ".debugger/vsdbg-ui"
        ".debugger/vsdbg"
      ];
      darwinX86DebuggerBins = [
        ".debugger/x86_64/vsdbg-ui"
        ".debugger/x86_64/vsdbg"
      ];
      darwinAarch64DebuggerBins = [
        ".debugger/arm64/vsdbg-ui"
        ".debugger/arm64/vsdbg"
      ];
      omniSharpBins = [
        ".omnisharp/1.39.0-net6.0/OmniSharp"
      ];
      razorBins = [
        ".razor/createdump"
        ".razor/rzls"
      ];
    in
      {
        x86_64-linux = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-linux-x64.vsix";
          sha256 = "1cqqjg8q6v56b19aabs9w1kxly457mpm0akbn5mis9nd1mrdmydl";
          binaries = linuxDebuggerBins ++ omniSharpBins ++ razorBins;
        };
        aarch64-linux = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-linux-arm64.vsix";
          sha256 = "0nsjgrb7y4w71w1gnrf50ifwbmjidi4vrw2fyfmch7lgjl8ilnhd";
          binaries = linuxDebuggerBins ++ omniSharpBins; # Linux aarch64 version has no Razor Language Server
        };
        x86_64-darwin = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-darwin-x64.vsix";
          sha256 = "01qn398vmjfi9imzlmzm0qi7y2h214wx6a8la088lfkhyj3gfjh8";
          binaries = darwinX86DebuggerBins ++ omniSharpBins ++ razorBins;
        };
        aarch64-darwin = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-darwin-arm64.vsix";
          sha256 = "020j451innh7jzarbv1ij57rfmqnlngdxaw6wdgp8sjkgbylr634";
          binaries = darwinAarch64DebuggerBins ++ darwinX86DebuggerBins ++ omniSharpBins ++ razorBins;
        };
      }.${system} or (throw "Unsupported system: ${system}");
in
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "csharp";
    publisher = "ms-dotnettools";
    inherit version;
  };

  vsix = fetchurl {
    name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
    inherit (vsixInfo) url sha256;
  };

  nativeBuildInputs = [
    patchelf
  ];

  postPatch = ''
    declare ext_unique_id
    # See below as to why we cannot take the whole basename.
    ext_unique_id="$(basename "$out" | head -c 32)"

    # Fix 'Unable to connect to debuggerEventsPipeName .. exceeds the maximum length 107.' when
    # attempting to launch a specific test in debug mode. The extension attemps to open
    # a pipe in extension dir which would fail anyway. We change to target file path
    # to a path in tmp dir with a short name based on the unique part of the nix store path.
    # This is however a brittle patch as we're working on minified code.
    # Hence the attempt to only hold on stable names.
    # However, this really would better be fixed upstream.
    sed -i \
      -E -e 's/(this\._pipePath=[a-zA-Z0-9_]+\.join\()([a-zA-Z0-9_]+\.getExtensionPath\(\)[^,]*,)/\1require("os").tmpdir(), "'"$ext_unique_id"'"\+/g' \
      "$PWD/dist/extension.js"

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
        --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc openssl icu.out ]}:\$ORIGIN" \
        "$elf"
    }

  '' + (lib.concatStringsSep "\n" (map
    (bin: ''
      chmod +x "${bin}"
    '')
    vsixInfo.binaries))
  + lib.optionalString stdenv.isLinux (lib.concatStringsSep "\n" (map
    (bin: ''
      patchelf_common "${bin}"
    '')
    vsixInfo.binaries));

  meta = with lib; {
    description = "C# for Visual Studio Code (powered by OmniSharp)";
    homepage = "https://github.com/OmniSharp/omnisharp-vscode";
    license = licenses.mit;
    maintainers = [ maintainers.jraygauthier ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
