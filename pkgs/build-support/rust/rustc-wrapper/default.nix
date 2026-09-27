{
  lib,
  runCommand,
  rustc-unwrapped,
  sysroot ? null,
  stdenvNoCC,
  shell ? stdenvNoCC.shell,
}:
let
  sysrootFlag = lib.optionalString (sysroot != null) "--sysroot ${sysroot}";

  # Upstream rustc still assumes that musl = static[1].  The fix for
  # this is to disable crt-static by default for non-static musl
  # targets.
  #
  # Even though Cargo will build build.rs files for the build platform,
  # cross-compiling _from_ musl appears to work fine, so we only need
  # to do this when rustc's target platform is dynamically linked musl.
  #
  # [1]: https://github.com/rust-lang/compiler-team/issues/422
  #
  # WARNING: using defaultArgs is dangerous, as it will apply to all
  # targets used by this compiler (host and target).  This means
  # that it can't be used to set arguments that should only be
  # applied to the target.  It's fine to do this for -crt-static,
  # because rustc does not support +crt-static host platforms
  # anyway.
  defaultArgs = lib.optionalString (
    with rustc-unwrapped.stdenv.targetPlatform; isMusl && !isStatic
  ) "-C target-feature=-crt-static";
in
runCommand "${rustc-unwrapped.pname}-wrapper-${rustc-unwrapped.version}"
  {
    preferLocalBuild = true;
    strictDeps = true;
    inherit (rustc-unwrapped) outputs;

    passthru = {
      inherit (rustc-unwrapped)
        pname
        version
        src
        llvm
        llvmPackages
        targetPlatforms
        targetPlatformsWithHostTools
        badTargetPlatforms
        ;
      unwrapped = rustc-unwrapped;
    };

    meta = rustc-unwrapped.meta // {
      description = "${rustc-unwrapped.meta.description} (wrapper script)";
      priority = 10;
    };
  }
  ''
    mkdir -p $out/bin
    ln -s ${rustc-unwrapped}/bin/* $out/bin
    rm $out/bin/{rustc,rustdoc}
    substitute ${./rustc-wrapper.sh} $out/bin/rustc \
      --replace-fail "@shell@" ${lib.escapeShellArg shell} \
      --replace-fail "@sysrootFlag@" ${lib.escapeShellArg sysrootFlag} \
      --replace-fail "@defaultArgs@" ${lib.escapeShellArg defaultArgs} \
      --replace-fail "@prog@" ${lib.escapeShellArg rustc-unwrapped}/bin/rustc \
      --replace-fail "@extraFlagsVar@" "NIX_RUSTFLAGS"
    substitute ${./rustc-wrapper.sh} $out/bin/rustdoc \
      --replace-fail "@shell@" ${lib.escapeShellArg shell} \
      --replace-fail "@sysrootFlag@" ${lib.escapeShellArg sysrootFlag} \
      --replace-fail "@defaultArgs@" ${lib.escapeShellArg defaultArgs} \
      --replace-fail "@prog@" ${lib.escapeShellArg rustc-unwrapped}/bin/rustdoc \
      --replace-fail "@extraFlagsVar@" "NIX_RUSTDOCFLAGS"
    chmod +x $out/bin/{rustc,rustdoc}
    ${lib.concatMapStrings (output: "ln -s ${rustc-unwrapped.${output}} \$${output}\n") (
      lib.remove "out" rustc-unwrapped.outputs
    )}
  ''
