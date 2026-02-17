{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.environment.memoryAllocator;

  # The set of alternative malloc(3) providers.
  providers = {
    graphene-hardened = {
      libPath = "${pkgs.graphene-hardened-malloc}/lib/libhardened_malloc.so";
      description = ''
        Hardened memory allocator coming from GrapheneOS project.
        The default configuration template has all normal optional security
        features enabled and is quite aggressive in terms of sacrificing
        performance and memory usage for security.
      '';
    };

    graphene-hardened-light = {
      libPath = "${pkgs.graphene-hardened-malloc}/lib/libhardened_malloc-light.so";
      description = ''
        Hardened memory allocator coming from GrapheneOS project.
        The light configuration template disables the slab quarantines,
        write after free check, slot randomization and raises the guard
        slab interval from 1 to 8 but leaves zero-on-free and slab canaries enabled.
        The light configuration has solid performance and memory usage while still
        being far more secure than mainstream allocators with much better security
        properties.
      '';
    };

    jemalloc = {
      libPath = "${pkgs.jemalloc}/lib/libjemalloc.so";
      description = ''
        A general purpose allocator that emphasizes fragmentation avoidance
        and scalable concurrency support.
      '';
    };

    scudo =
      let
        platformMap = {
          aarch64-linux = "aarch64";
          x86_64-linux = "x86_64";
        };

        systemPlatform =
          platformMap.${pkgs.stdenv.hostPlatform.system}
            or (throw "scudo not supported on ${pkgs.stdenv.hostPlatform.system}");
      in
      {
        libPath = "${pkgs.llvmPackages.compiler-rt}/lib/linux/libclang_rt.scudo_standalone-${systemPlatform}.so";
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
  mallocLib =
    pkgs.runCommand "malloc-provider-${cfg.provider}"
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
    maintainers = [ lib.maintainers.joachifm ];
  };

  options = {
    environment.memoryAllocator.provider = lib.mkOption {
      type = lib.types.enum ([ "libc" ] ++ lib.attrNames providers);
      default = "libc";
      description = ''
        The system-wide memory allocator.

        Briefly, the system-wide memory allocator providers are:

        - `libc`: the standard allocator provided by libc
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: value: "- `${name}`: ${lib.replaceStrings [ "\n" ] [ " " ] value.description}"
          ) providers
        )}

        ::: {.warning}
        Selecting an alternative allocator (i.e., anything other than
        `libc`) may result in instability, data loss,
        and/or service failure.
        :::
      '';
    };
  };

  config = lib.mkIf (cfg.provider != "libc") {
    environment.etc."ld-nix.so.preload".text = ''
      ${providerLibPath}
    '';
    security.apparmor.includes = {
      "abstractions/base" = ''
        r /etc/ld-nix.so.preload,
        r ${config.environment.etc."ld-nix.so.preload".source},
        include "${
          pkgs.apparmorRulesFromClosure {
            name = "mallocLib";
            baseRules = [ "mr $path/lib/**.so*" ];
          } [ mallocLib ]
        }"
      '';
    };
  };
}
