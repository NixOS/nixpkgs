{ cfg, lib, ... }:
let
  configLines = (
    [
      (lib.optionalString cfg.os '' info "OS" distro\n'')
      (lib.optionalString cfg.host '' info "Host" model\n'')
      (lib.optionalString cfg.kernel '' info "Kernel" kernel\n'')
      (lib.optionalString cfg.uptime '' info "Uptime" uptime\n'')
      (lib.optionalString cfg.packages '' info "Packages" packages\n'')
      (lib.optionalString cfg.shell ''  info "Shell" shell\n'')
      (lib.optionalString cfg.resolution '' info "Resolution" resolution\n'')
      (lib.optionalString cfg.de '' info "DE" de\n'')
      (lib.optionalString cfg.wm '' info "WM" wm\n'')
      (lib.optionalString cfg.wm_theme '' info "WM Theme"\n wm_theme null)
      (lib.optionalString cfg.theme ''  info "Theme" theme\n'')
      (lib.optionalString cfg.icons ''  info "Icons" icons\n'')
      (lib.optionalString cfg.terminal '' info "Terminal" term\n'')
      (lib.optionalString cfg.terminal_font ''  info "Terminal Font"\n term_font null)
      (lib.optionalString cfg.cpu ''  info "CPU" cpu\n'')
      (lib.optionalString cfg.gpu ''  info "GPU" gpu\n'')
      (lib.optionalString cfg.memory '' info "Memory" memory\n'')
      (lib.optionalString cfg.cpu_usage ''  info "CPU Usage"\n cpu_usage null)
      (lib.optionalString cfg.disk '' info "Disk" disk\n'')
      (lib.optionalString cfg.battery ''  info "Battery" battery\n'')
      (lib.optionalString cfg.font '' info "Font" font\n'')
      (lib.optionalString cfg.song '' info "Song" song\n'')
      (lib.optionalString cfg.local_ip '' info "Local IP"\n local_ip null)
      (lib.optionalString cfg.public_ip ''  info "Public IP"\n public_ip null)
      (lib.optionalString cfg.users ''  info "Users" users\n'')
      (lib.optionalString cfg.birthday '' info "Birthday" birthday\n'')
    ]
  );
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
