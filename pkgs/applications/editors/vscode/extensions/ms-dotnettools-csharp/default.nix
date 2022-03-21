{ lib
, fetchurl
, vscode-utils
, unzip
, patchelf
, makeWrapper
, icu
, stdenv
, openssl
, mono
}:

let
  # Get as close as possible as the `package.json` required version.
  # This is what drives omnisharp.
  rtDepsSrcsFromJson = lib.importJSON ./rt-deps-bin-srcs.json;

  rtDepsBinSrcs = builtins.mapAttrs (k: v:
      let
        # E.g: "OmniSharp-x86_64-linux"
        kSplit = builtins.split "(__)" k;
        name = builtins.elemAt kSplit 0;
        system = builtins.elemAt kSplit 2;
      in
      {
        inherit name system;
        installPath = v.installPath;
        binaries = v.binaries;
        bin-src = fetchurl {
          urls = v.urls;
          inherit (v) sha256;
        };
      }
    )
    rtDepsSrcsFromJson;

  rtDepBinSrcByName = bSrcName:
    rtDepsBinSrcs."${bSrcName}__${stdenv.targetPlatform.system}";

  omnisharp = rtDepBinSrcByName "OmniSharp";
  vsdbgs = [
    (rtDepBinSrcByName "Debugger")
  ] ++ lib.optionals (stdenv.isDarwin) [
  # Include the aarch64-darwin debugger binaries on x86_64-darwin.  Even though OmniSharp will be
  # running under Rosetta 2, debugging will fail to start if both sets of binaries are not present.
    (rtDepsBinSrcs."Debugger__aarch64-darwin")
  ];
  razor = rtDepBinSrcByName "Razor";
in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "csharp";
    publisher = "ms-dotnettools";
    version = "1.23.16";
    sha256 = "sha256-fM4vcSMi2tEjIox9Twh2sRiFhXgAeRwAM9to3vtcSqI=";
  };

  nativeBuildInputs = [
    unzip
    patchelf
    makeWrapper
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

    unzip_to() {
      declare src_zip="''${1?}"
      declare target_dir="''${2?}"
      mkdir -p "$target_dir"
      if unzip "$src_zip" -d "$target_dir"; then
        true
      elif [[ "1" -eq "$?" ]]; then
        1>&2 echo "WARNING: unzip('$?' -> skipped files)."
      else
        1>&2 echo "ERROR: unzip('$?')."
      fi
    }

    patchelf_add_icu_as_needed() {
      declare elf="''${1?}"
      declare icu_major_v="${
        with builtins; head (splitVersion (parseDrvName icu.name).version)}"

      for icu_lib in icui18n icuuc icudata; do
        patchelf --add-needed "lib''${icu_lib}.so.$icu_major_v" "$elf"
      done
    }

    patchelf_common() {
      declare elf="''${1?}"

      patchelf_add_icu_as_needed "$elf"
      patchelf --add-needed "libssl.so" "$elf"
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc openssl.out icu.out ]}:\$ORIGIN" \
        "$elf"
    }

    declare omnisharp_dir="$PWD/${omnisharp.installPath}"
    unzip_to "${omnisharp.bin-src}" "$omnisharp_dir"
    rm "$omnisharp_dir/bin/mono"
    ln -s -T "${mono}/bin/mono" "$omnisharp_dir/bin/mono"
    chmod a+x "$omnisharp_dir/run"
    touch "$omnisharp_dir/install.Lock"

  '' + builtins.concatStringsSep "\n" (map (vsdbg: ''
    declare vsdbg_dir="$PWD/${vsdbg.installPath}"
    unzip_to "${vsdbg.bin-src}" "$vsdbg_dir"
    chmod a+x "$vsdbg_dir/vsdbg-ui"
    chmod a+x "$vsdbg_dir/vsdbg"
    touch "$vsdbg_dir/install.complete"
    touch "$vsdbg_dir/install.Lock"

  '') vsdbgs) + ''
    declare razor_dir="$PWD/${razor.installPath}"
    unzip_to "${razor.bin-src}" "$razor_dir"
    chmod a+x "$razor_dir/rzls"
    touch "$razor_dir/install.Lock"

  '' + lib.optionalString stdenv.isLinux ''
    patchelf_common "$vsdbg_dir/vsdbg"
    patchelf_common "$vsdbg_dir/vsdbg-ui"
    patchelf_common "$razor_dir/rzls"

  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace $omnisharp_dir/etc/config \
      --replace "libmono-native-compat.dylib" "libmono-native.dylib"
  '';

  meta = with lib; {
    description = "C# for Visual Studio Code (powered by OmniSharp)";
    homepage = "https://github.com/OmniSharp/omnisharp-vscode";
    license = licenses.mit;
    maintainers = [ maintainers.jraygauthier ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
