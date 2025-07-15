{
  lib,
  vscode-utils,
  jq,
  clang-tools,
  gdbUseFixed ? true,
  gdb, # The gdb default setting will be fixed to specified. Use version from `PATH` otherwise.
  autoPatchelfHook,
  makeWrapper,
  stdenv,
  lttng-ust,
  libkrb5,
  zlib,
}:

/*
  Note that this version of the extension still has some nix specific issues
  which could not be fixed merely by patching (inside a C# dll).

  In particular, the debugger requires either gnome-terminal or xterm. However
  instead of looking for the terminal executable in `PATH`, for any linux platform
  the dll uses an hardcoded path to one of these.

  So, in order for debugging to work properly, you merely need to create symlinks
  to one of these terminals at the appropriate location.

  The good news is the the utility library is open source and with some effort
  we could build a patched version ourselves. See:

  <https://github.com/Microsoft/MIEngine/blob/2885386dc7f35e0f1e44827269341e786361f28e/src/MICore/TerminalLauncher.cs#L156>

  Also, the extension should eventually no longer require an external terminal. See:

  <https://github.com/Microsoft/vscode-cpptools/issues/35>

  Once the symbolic link temporary solution taken, everything should run smootly.
*/

let
  gdbDefaultsTo = if gdbUseFixed then "${gdb}/bin/gdb" else "gdb";
  isx86Linux = stdenv.hostPlatform.system == "x86_64-linux";
  isDarwin = stdenv.hostPlatform.isDarwin;
  supported = {
    x86_64-linux = {
      hash = "sha256-JES5esVW6cRlrmFAQO1yLYEZbLdQu4ILW0rjDBp5Ek4=";
      arch = "linux-x64";
    };
    aarch64-linux = {
      hash = "sha256-fZzYzR2wHbCCllhyu4fI2ekPu3fMngUmeJawhkYdWyA=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-fPtCIOYvbO/S06io9lFAXxkB/6g00GO5+RXt5aewPME=";
      arch = "darwin-arm64";
    };
  };

  base =
    supported.${stdenv.hostPlatform.system}
      or (throw "unsupported platform ${stdenv.hostPlatform.system}");
in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    name = "cpptools";
    publisher = "ms-vscode";
    version = "1.26.3";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    jq
    libkrb5
    zlib
    (lib.getLib stdenv.cc.cc)
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ lttng-ust ];

  dontAutoPatchelf = isx86Linux || isDarwin;

  postPatch =
    ''
      mv ./package.json ./package_orig.json

      # 1. Add activation events so that the extension is functional. This listing is empty when unpacking the extension but is filled at runtime.
      # 2. Patch `package.json` so that nix's *gdb* is used as default value for `miDebuggerPath`.
      cat ./package_orig.json | \
        jq --slurpfile actEvts ${./package-activation-events.json} '(.activationEvents) = $actEvts[0]' | \
        jq '(.contributes.debuggers[].configurationAttributes | .attach , .launch | .properties.miDebuggerPath | select(. != null) | select(.default == "/usr/bin/gdb") | .default) = "${gdbDefaultsTo}"' > \
        ./package.json

      # Prevent download/install of extensions
      touch "./install.lock"

      # Clang-format from nix package.
      rm -rf ./LLVM
      mkdir "./LLVM/"
      find "${clang-tools}" -mindepth 1 -maxdepth 1 | xargs ln -s -t "./LLVM"

      # Patching binaries
      chmod +x bin/cpptools bin/cpptools-srv bin/cpptools-wordexp debugAdapters/bin/OpenDebugAD7
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so.1 ./debugAdapters/bin/libcoreclrtraceptprovider.so
    ''
    + lib.optionalString isx86Linux ''
      chmod +x bin/libc.so
    ''
    + lib.optionalString isDarwin ''
      chmod +x debugAdapters/lldb-mi/bin/lldb-mi
    '';

  # On aarch64 the binaries are statically linked
  # but on x86 they are not.
  postFixup =
    lib.optionalString isx86Linux ''
      autoPatchelf $out/share/vscode/extensions/ms-vscode.cpptools/debugAdapters
      # cpptools* are distributed by the extension and need to be run through the distributed musl interpretter
      patchelf --set-interpreter $out/share/vscode/extensions/ms-vscode.cpptools/bin/libc.so $out/share/vscode/extensions/ms-vscode.cpptools/bin/cpptools
      patchelf --set-interpreter $out/share/vscode/extensions/ms-vscode.cpptools/bin/libc.so $out/share/vscode/extensions/ms-vscode.cpptools/bin/cpptools-srv
      patchelf --set-interpreter $out/share/vscode/extensions/ms-vscode.cpptools/bin/libc.so $out/share/vscode/extensions/ms-vscode.cpptools/bin/cpptools-wordexp
    ''
    + lib.optionalString gdbUseFixed ''
      wrapProgram $out/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7 --prefix PATH : ${lib.makeBinPath [ gdb ]}
    '';

  meta = {
    description = "C/C++ extension adds language support for C/C++ to Visual Studio Code, including features such as IntelliSense and debugging";
    homepage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      jraygauthier
      stargate01
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
