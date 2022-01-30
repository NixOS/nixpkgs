{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.environment.memoryAllocator;

  # The set of alternative malloc(3) providers.
  providers = import ./malloc-providers.nix { inherit pkgs; };

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
      description = ''
        The system-wide memory allocator.

        Briefly, the system-wide memory allocator providers are:
        <itemizedlist>
        <listitem><para><literal>libc</literal>: the standard allocator provided by libc</para></listitem>
        ${toString (mapAttrsToList
            (name: value: "<listitem><para><literal>${name}</literal>: ${value.description}</para></listitem>")
            providers)}
        </itemizedlist>

        <warning>
        <para>
        Selecting an alternative allocator (i.e., anything other than
        <literal>libc</literal>) may result in instability, data loss,
        and/or service failure.
        </para>
        </warning>
      '';
    };
  };

  config = mkIf (cfg.provider != "libc") {
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
