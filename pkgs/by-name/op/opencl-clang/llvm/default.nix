{
  newScope,
  lib,
  fetchFromGitHub,
  wrapCCWith,
  buildPackages,
  buildLlvmTools, # tools, but from the previous stage, for cross
  targetLlvmLibraries, # libraries, but from the next stage, for cross
  sha256,
  version,
  ...
}@args:

let
  metadata = rec {
    inherit
      (import ./common-let.nix {
        inherit
          lib
          fetchFromGitHub
          sha256
          version
          ;
      })
      llvm_meta
      monorepoSrc
      ;
    src = monorepoSrc;
  };

  tools = lib.makeExtensible (
    tools:
    let
      callPackage = newScope (tools // args // metadata);
      mkExtraBuildCommands0 =
        cc:
        ''
          rsrc="$out/resource-root"
          mkdir "$rsrc"
          echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
        ''
        + ''
          ln -s "${lib.getLib cc}/lib/clang/${version}/include" "$rsrc"
        '';
      mkExtraBuildCommands =
        cc:
        mkExtraBuildCommands0 cc
        + ''
          ln -s "${targetLlvmLibraries.compiler-rt.out}/lib" "$rsrc/lib"
          ln -s "${targetLlvmLibraries.compiler-rt.out}/share" "$rsrc/share"
        '';
    in
    {
      compiler-rt = libraries.compiler-rt-libc;

      libllvm = callPackage ./llvm {
        inherit (buildPackages.opencl-clang.llvmPkgs) tblgen;
      };

      # `llvm` historically had the binaries.  When choosing an output explicitly,
      # we need to reintroduce `outputSpecified` to get the expected behavior e.g. of lib.get*
      llvm = tools.libllvm;

      tblgen = callPackage ./tblgen.nix {
        patches =
          builtins.filter
            # Crude method to drop polly patches if present, they're not needed for tblgen.
            (p: (!lib.hasInfix "-polly" p))
            tools.libllvm.patches;
        clangPatches =
          # Would take tools.libclang.patches, but this introduces a cycle due
          # to replacements depending on the llvm outpath (e.g. the LLVMgold patch).
          # So take the only patch known to be necessary.
          ./clang/gnu-install-dirs.patch;
      };

      libclang = callPackage ./clang {
        inherit (buildPackages.opencl-clang.llvmPkgs) tblgen;
      };

      clang-unwrapped = tools.libclang;

      # pick clang appropriate for package set we are targeting
      clang = tools.libstdcxxClang;

      libstdcxxClang = wrapCCWith rec {
        cc = tools.clang-unwrapped;
        extraPackages = [ targetLlvmLibraries.compiler-rt ];
        extraBuildCommands = mkExtraBuildCommands cc;
      };

      lld = callPackage ./lld { };
    }
  );

  libraries = lib.makeExtensible (
    libraries:
    let
      callPackage = newScope (libraries // buildLlvmTools // args // metadata);
    in
    {
      compiler-rt-libc = callPackage ./compiler-rt { };

      compiler-rt = libraries.compiler-rt-libc;
    }
  );

  noExtend = extensible: lib.attrsets.removeAttrs extensible [ "extend" ];
in
{
  inherit tools libraries;
  inherit (metadata) version;
}
// (noExtend libraries)
// (noExtend tools)
