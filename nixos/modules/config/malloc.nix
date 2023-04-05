{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.environment.memoryAllocator;

  # The set of alternative malloc(3) providers.
  providers = {
    graphene-hardened = {
      libPath = "${pkgs.graphene-hardened-malloc}/lib/libhardened_malloc.so";
      description = ''
        An allocator designed to mitigate memory corruption attacks, such as
        those caused by use-after-free bugs.
      '';
    };

    jemalloc = {
      libPath = "${pkgs.jemalloc}/lib/libjemalloc.so";
      description = ''
        A general purpose allocator that emphasizes fragmentation avoidance
        and scalable concurrency support.
      '';
    };

    scudo = let
      platformMap = {
        aarch64-linux = "aarch64";
        x86_64-linux  = "x86_64";
      };

      systemPlatform = platformMap.${pkgs.stdenv.hostPlatform.system} or (throw "scudo not supported on ${pkgs.stdenv.hostPlatform.system}");
    in {
      libPath = "${pkgs.llvmPackages_latest.compiler-rt}/lib/linux/libclang_rt.scudo-${systemPlatform}.so";
      description = ''
        A user-mode allocator based on LLVM Sanitizer’s CombinedAllocator,
        which aims at providing additional mitigations against heap based
        vulnerabilities, while maintaining good performance.
      '';
    };

    mimalloc = {
      libPath = "${pkgs.mimalloc}/lib/libmimalloc.so";
      description = ''
        A compact and fast general purpose allocator, which may
        optionally be built with mitigations against various heap
        vulnerabilities.
      '';
    };
  };

  providerConf = providers.${cfg.provider};

  # An output that contains only the shared library, to avoid
  # needlessly bloating the system closure
  mallocLib = pkgs.runCommand "malloc-provider-${cfg.provider}"
    rec {
      preferLocalBuild = true;
      allowSubstitutes = false;
      origLibPath = providerConf.libPath;
      libName = baseNameOf origLibPath;
    }
    ''
      mkdir -p $out/lib
      cp -L $origLibPath $out/lib/$libName
    '';

  # The full path to the selected provider shlib.
  providerLibPath = "${mallocLib}/lib/${mallocLib.libName}";
in

{
  meta = {
    maintainers = [ maintainers.joachifm ];
  };

  options = {
    environment.memoryAllocator.provider = mkOption {
      type = types.enum ([ "libc" ] ++ attrNames providers);
      default = "libc";
      description = lib.mdDoc ''
        The system-wide memory allocator.

        Briefly, the system-wide memory allocator providers are:

        - `libc`: the standard allocator provided by libc
        ${concatStringsSep "\n" (mapAttrsToList
            (name: value: "- `${name}`: ${replaceStrings [ "\n" ] [ " " ] value.description}")
            providers)}

        ::: {.warning}
        Selecting an alternative allocator (i.e., anything other than
        `libc`) may result in instability, data loss,
        and/or service failure.
        :::
      '';
    };
  };

  config = mkIf (cfg.provider != "libc") {
    boot.kernel.sysctl."vm.max_map_count" = mkIf (cfg.provider == "graphene-hardened") (mkDefault 1048576);
    environment.etc."ld-nix.so.preload".text = ''
      ${providerLibPath}
    '';
    security.apparmor.includes = {
      "abstractions/base" = ''
        r /etc/ld-nix.so.preload,
        r ${config.environment.etc."ld-nix.so.preload".source},
        include "${pkgs.apparmorRulesFromClosure {
            name = "mallocLib";
            baseRules = ["mr $path/lib/**.so*"];
          } [ mallocLib ] }"
      '';
    };
  };
}
