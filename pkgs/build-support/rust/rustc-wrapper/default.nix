{
  lib,
  runCommand,
  package,
  sysroot ? null,
  flavor ? "rustc",
  makeWrapper,
  rustc,
  cargo,
}:

runCommand "${package.pname}-wrapper-${package.version}"
  {
    preferLocalBuild = true;
    strictDeps = true;
    inherit (package) outputs;

    env = {
      sysroot = lib.optionalString (sysroot != null) "--sysroot ${sysroot}";

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
        with package.stdenv.targetPlatform; isMusl && !isStatic
      ) "-C target-feature=-crt-static";
    };

    depsBuildBuild = lib.optionals (flavor == "clippy") [ makeWrapper ];

    passthru = {
      inherit (package)
        pname
        version
        src
        llvm
        llvmPackages
        tier1TargetPlatforms
        targetPlatforms
        badTargetPlatforms
        ;
      unwrapped = package;
    };

    meta = package.meta // {
      description = "${package.meta.description} (wrapper script)";
      priority = 10;
    };
  }
  (
    if flavor == "rustc" then
      ''
        mkdir -p $out/bin
        ln -s ${package}/bin/* $out/bin
        rm $out/bin/{rustc,rustdoc}
        prog=${package}/bin/rustc extraFlagsVar=NIX_RUSTFLAGS \
            substituteAll ${./rustc-wrapper.sh} $out/bin/rustc
        prog=${package}/bin/rustdoc extraFlagsVar=NIX_RUSTDOCFLAGS \
            substituteAll ${./rustc-wrapper.sh} $out/bin/rustdoc
        chmod +x $out/bin/{rustc,rustdoc}
        ${lib.concatMapStrings (output: "ln -s ${package.${output}} \$${output}\n") (
          lib.remove "out" package.outputs
        )}
      ''
    else if flavor == "clippy" then
      ''
        mkdir -p $out/bin
        prog=${package}/bin/clippy-driver extraFlagsVar=NIX_CLIPPY_DRIVERFLAGS \
            substituteAll ${./clippy-wrapper.sh} $out/bin/clippy-driver

        chmod +x $out/bin/clippy-driver

        makeWrapper ${package}/bin/cargo-clippy $out/bin/cargo-clippy \
            --set CLIPPY_DRIVER $out/bin/clippy-driver \
            --prefix PATH : ${
              lib.makeBinPath [
                rustc
                cargo
              ]
            }

        ${lib.concatMapStrings (output: "ln -s ${package.${output}} \$${output}\n") (
          lib.remove "out" package.outputs
        )}
      ''
    else
      throw "Invalid rustc flavor: ${flavor}"
  )
