# 青简输入法（Linux）NixOS 模块。
#
# 作用：
#   1) 把聚合包 pkgs.qingjian（qingjian-server + fcitx5 插件 + 离线词库/整句模型）
#      并进 `i18n.inputMethod.fcitx5.addons`；
#   2) 以用户级 systemd 服务拉起 qingjian-server（图形会话内，登录即用）。
#
# 配置哲学（混合式）：
#   - 基础设施（装不装 / 服务怎么跑 / 额外数据源）→ 本模块声明式 options；
#   - 个人偏好（词库开关、按键、候选样式、整句模型开关等）→ 官方运行时
#     ~/.config/qingjian/config.toml（改完重启 qingjian-server 生效）。
#     想声明式管默认值的用户可设 initialConfigFile：首次启动写入一份真实文件，
#     之后仍可运行时修改，rebuild 不会覆盖。
#
# 用法（NixOS 配置里）：
#   services.qingjian.enable = true;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qingjian;
in
{
  options.services.qingjian = {
    enable = lib.mkEnableOption "青简输入法（fcitx5 插件 + 本地 Rust server）";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qingjian;
      defaultText = lib.literalExpression "pkgs.qingjian";
      description = ''
        青简聚合包（qingjian-server + fcitx5 插件 + 离线词库/整句模型）。
        默认使用 nixpkgs 的 pkgs.qingjian；需要自定义构建时覆盖。
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        可选的自定义资源根目录（含 data/generated、data/models/hanzhang-*、assets
        等官方约定的子目录）。默认不设置：聚合包内已内置官方 data-v3 数据，
        server 启动时自动定位 $out/share/qingjian/resources，无需环境变量。
        覆盖时以 QINGJIAN_RESOURCES 注入自定义目录。
      '';
    };

    serverArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--log-level"
        "debug"
      ];
      description = "追加传给 qingjian-server 的命令行参数。";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        RUST_LOG = "debug";
      };
      description = "追加注入服务进程的环境变量。";
    };

    initialConfigFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        可选的初始配置（官方 config.toml）。设置后首次启动写入
        ~/.config/qingjian/config.toml；文件已存在时**不会覆盖**（保留运行时修改）。
        不设置则完全走官方运行时默认。
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod.fcitx5.addons = [ cfg.package ];

    # 用户级服务：与 fcitx5 同会话（graphical-session），重启即拉起。
    # 注意：NixOS systemd 服务的 option 是顶层小写属性 + serviceConfig/unitConfig，
    # 没有 Unit/Service/Install 子段。
    systemd.user.services.qingjian-server = {
      description = "qingjian 输入法 Rust server";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      # 这两个 option 在 nixpkgs 26.x 无默认值但 unit 生成时会读取，显式对齐 systemd 原生默认
      startLimitIntervalSec = 10;
      startLimitBurst = 5;
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${cfg.package}/bin/qingjian-server"
          + lib.optionalString (cfg.serverArgs != [ ]) (" " + lib.concatStringsSep " " cfg.serverArgs);
        Restart = "on-failure";
        RestartSec = "2";
        Environment =
          (if cfg.dataDir != null then [ "QINGJIAN_RESOURCES=${toString cfg.dataDir}" ] else [ ])
          ++ lib.mapAttrsToList (name: value: "${name}=${value}") cfg.extraEnvironment;
        # 首次启动注入初始 config.toml（不存在才写，保留运行时修改）
        ExecStartPre = lib.mkIf (cfg.initialConfigFile != null) [
          (lib.concatStringsSep " " [
            "${pkgs.bash}/bin/bash"
            "-c"
            "mkdir -p %h/.config/qingjian && [ -e %h/.config/qingjian/config.toml ] || install -m 600 ${cfg.initialConfigFile} %h/.config/qingjian/config.toml"
          ])
        ];
      };
    };
  };
}
