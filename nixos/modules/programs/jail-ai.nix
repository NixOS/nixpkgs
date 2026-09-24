{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.jail-ai;
in
{
  options.programs.jail-ai = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to install jail-ai and a setcap wrapper for
        `jail-ai-ebpf-loader`, the helper it uses to load its eBPF host
        blocker. The helper needs `CAP_BPF` and `CAP_NET_ADMIN`; without the
        wrapper, creating a jail fails unless `--no-block-host` is passed.
      '';
    };

    package = lib.mkPackageOption pkgs "jail-ai" { };

    group = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "jail-ai";
      description = ''
        Restrict the eBPF loader to members of this group. When null, it stays
        executable by everyone, like the `setcap` setup documented upstream.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package.withEbpf or false;
        message = "programs.jail-ai requires a jail-ai built with `withEbpf = true`.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    # jail-ai looks the loader up in PATH, which finds /run/wrappers/bin first.
    security.wrappers.jail-ai-ebpf-loader = {
      source = "${cfg.package}/bin/jail-ai-ebpf-loader";
      capabilities = "cap_bpf,cap_net_admin+ep";
      owner = "root";
      group = if cfg.group == null then "root" else cfg.group;
      permissions = if cfg.group == null then "u+rx,g+x,o+x" else "u+rx,g+x";
    };
  };

  meta.maintainers = with lib.maintainers; [ FlorianFranzen ];
}
