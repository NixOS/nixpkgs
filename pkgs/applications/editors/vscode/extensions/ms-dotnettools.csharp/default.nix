{ lib
, fetchurl
, vscode-utils
, patchelf
, icu
, stdenv
, openssl
, coreutils
}:
let
  inherit (stdenv.hostPlatform) system;

  version = "1.25.4";

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
        ".omnisharp/1.39.4-net6.0/OmniSharp"
      ];
      razorBins = [
        ".razor/createdump"
        ".razor/rzls"
      ];
    in
      {
        x86_64-linux = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-linux-x64.vsix";
          sha256 = "08k0wxyj8wz8npw1yqrkdpbvwbnrdnsngdkrd2p5ayn3v608ifc2";
          binaries = linuxDebuggerBins ++ omniSharpBins ++ razorBins;
        };
        aarch64-linux = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-linux-arm64.vsix";
          sha256 = "09r2d463dk35905f2c3msqzxa7ylcf0ynhbp3n6d12y3x1200pr2";
          binaries = linuxDebuggerBins ++ omniSharpBins ++ razorBins;
        };
        x86_64-darwin = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-darwin-x64.vsix";
          sha256 = "0mp550kq33zwmlvrhymwnixl4has62imw3ia5z7a01q7mp0w9wpn";
          binaries = darwinX86DebuggerBins ++ omniSharpBins ++ razorBins;
        };
        aarch64-darwin = {
          url = "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${version}/csharp-${version}-darwin-arm64.vsix";
          sha256 = "08406xz2raal8f10bmnkz1mwdfprsbkjxzc01v0i4sax1hr2a2yl";
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

    # Fix reference to uname
    sed -i \
      -E -e 's_uname -m_${coreutils}/bin/uname -m_g' \
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

  meta = {
    description = "C# for Visual Studio Code (powered by OmniSharp)";
    homepage = "https://github.com/OmniSharp/omnisharp-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jraygauthier ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
