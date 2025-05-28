{ cfg, lib, ... }:
let
  configLines =
    (lib.filter (x: x != null) [
      (if cfg.os then ''info "OS" distro'' else null)
      (if cfg.host then ''info "Host" model'' else null)
      (if cfg.kernel then ''info "Kernel" kernel'' else null)
      (if cfg.uptime then ''info "Uptime" uptime'' else null)
      (if cfg.packages then ''info "Packages" packages'' else null)
      (if cfg.shell then ''info "Shell" shell'' else null)
      (if cfg.resolution then ''info "Resolution" resolution'' else null)
      (if cfg.de then ''info "DE" de'' else null)
      (if cfg.wm then ''info "WM" wm'' else null)
      (if cfg.wm_theme then ''info "WM Theme" wm_theme'' else null)
      (if cfg.theme then ''info "Theme" theme'' else null)
      (if cfg.icons then ''info "Icons" icons'' else null)
      (if cfg.terminal then ''info "Terminal" term'' else null)
      (if cfg.terminal_font then ''info "Terminal Font" term_font'' else null)
      (if cfg.cpu then ''info "CPU" cpu'' else null)
      (if cfg.gpu then ''info "GPU" gpu'' else null)
      (if cfg.memory then ''info "Memory" memory'' else null)
      (if cfg.cpu_usage then ''info "CPU Usage" cpu_usage'' else null)
      (if cfg.disk then ''info "Disk" disk'' else null)
      (if cfg.battery then ''info "Battery" battery'' else null)
      (if cfg.font then ''info "Font" font'' else null)
      (if cfg.song then ''info "Song" song'' else null)
      (if cfg.local_ip then ''info "Local IP" local_ip'' else null)
      (if cfg.public_ip then ''info "Public IP" public_ip'' else null)
      (if cfg.users then ''info "Users" users'' else null)
      (if cfg.birthday then ''info "Birthday" birthday'' else null)
    ]);
  configConf = ''
    print_info() {
      info title
      info underline
      ${lib.concatStringsSep "\n  " configLines}
      ${cfg.extraPrintInfoFields}
      info cols
    }
    cpu_temp="C"
    refresh_rate="on"
    ${cfg.extraGenericFields}
  '';
in
configConf
