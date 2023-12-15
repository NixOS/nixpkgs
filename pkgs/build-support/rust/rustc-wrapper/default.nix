{ lib, runCommand, rustc-unwrapped, sysroot ? null }:

runCommand "${rustc-unwrapped.pname}-wrapper-${rustc-unwrapped.version}" {
  preferLocalBuild = true;
  strictDeps = true;
  inherit (rustc-unwrapped) outputs;

  env = {
    prog = "${rustc-unwrapped}/bin/rustc";
    sysroot = lib.optionalString (sysroot != null) "--sysroot ${sysroot}";
  };

  passthru = {
    inherit (rustc-unwrapped) pname version src llvm llvmPackages;
    unwrapped = rustc-unwrapped;
  };

  meta = rustc-unwrapped.meta // {
    description = "${rustc-unwrapped.meta.description} (wrapper script)";
    priority = 10;
  };
} ''
  mkdir -p $out/bin
  ln -s ${rustc-unwrapped}/bin/* $out/bin
  rm $out/bin/rustc
  substituteAll ${./rustc-wrapper.sh} $out/bin/rustc
  chmod +x $out/bin/rustc
  ${lib.concatMapStrings (output: "ln -s ${rustc-unwrapped.${output}} \$${output}\n")
    (lib.remove "out" rustc-unwrapped.outputs)}
''
