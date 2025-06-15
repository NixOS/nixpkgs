{
  pkgs,
  python3,
  ...
}:
# propagatedBuildInputs are for Python libraries and executables
# buildInputs are for libraries
let
  py = python3.pkgs;
in
{
  amixer.propagatedBuildInputs = [ pkgs.alsa-utils ];
  # aptitude is unpackaged
  # apt.propagatedBuildInputs = [aptitude];
  arandr.propagatedBuildInputs = [
    py.tkinter
    pkgs.arandr
    pkgs.xorg.xrandr
  ];
  # checkupdates is unpackaged
  # arch-update.propagatedBuildInputs = [checkupdates];
  # checkupdates is unpackaged
  # arch_update.propagatedBuildInputs = [checkupdates];
  # yay is unpackaged
  # aur-update.propagatedBuildInputs = [yay];
  battery = { };
  battery-upower = { };
  battery_upower = { };
  bluetooth.propagatedBuildInputs = [
    pkgs.bluez
    pkgs.blueman
    pkgs.dbus
  ];
  bluetooth2.propagatedBuildInputs = [
    pkgs.bluez
    pkgs.blueman
    pkgs.dbus
    py.dbus-python
  ];
  blugon.propagatedBuildInputs = [ pkgs.blugon ];
  # If you do not allow this plugin to query the system's ACPI, i.e. the plugin option `use_acpi` is set to `False`, then you need at least one of [ brightnessctl light xbacklight ]
  brightness.propagatedBuildInputs = [ ];
  caffeine.propagatedBuildInputs = [
    pkgs.xdg-utils
    pkgs.xdotool
    pkgs.xorg.xprop
    pkgs.libnotify
  ];
  cmus.propagatedBuildInputs = [ pkgs.cmus ];
  cpu.propagatedBuildInputs = [
    py.psutil
    pkgs.gnome-system-monitor
  ];
  cpu2.propagatedBuildInputs = [
    py.psutil
    pkgs.lm_sensors
  ];
  cpu3.propagatedBuildInputs = [
    py.psutil
    pkgs.lm_sensors
  ];
  currency.propagatedBuildInputs = [ py.requests ];
  date = { };
  datetime = { };
  datetimetz.propagatedBuildInputs = [
    py.tzlocal
    py.pytz
  ];
  datetz = { };
  deadbeef.propagatedBuildInputs = [ pkgs.deadbeef ];
  debug = { };
  deezer.propagatedBuildInputs = [ py.dbus-python ];
  disk = { };
  # dnf is unpackaged
  # dnf.propagatedBuildInputs = [dnf];
  docker_ps.propagatedBuildInputs = [ py.docker ];
  dunst.propagatedBuildInputs = [ pkgs.dunst ];
  dunstctl.propagatedBuildInputs = [ pkgs.dunst ];
  # emerge is unpackaged
  # emerge_status.propagatedBuildInputs = [emerge];
  error = { };
  gcalendar.propagatedBuildInputs = [
    py.google-api-python-client
    py.google-auth-httplib2
    py.google-auth-oauthlib
  ];
  getcrypto.propagatedBuildInputs = [ py.requests ];
  git.propagatedBuildInputs = [
    pkgs.xcwd
    pkgs.pygit2
  ];
  github.propagatedBuildInputs = [ py.requests ];
  gitlab.propagatedBuildInputs = [ py.requests ];
  # gpmdp-remote is unpackaged
  # gpmdp.propagatedBuildInputs = [gpmdp-remote];
  hddtemp = { };
  hostname = { };
  http_status = { };
  indicator.propagatedBuildInputs = [ pkgs.xorg.xset ];
  kernel = { };
  keys = { };
  # python3Packages.xkbgroup is unpackaged
  layout = {
    buildInputs = [ pkgs.xorg.libX11 ];
    # propagatedBuildInputs = [py.xkbgroup];
  };
  # python3Packages.xkbgroup is unpackaged
  layout-xkb = {
    buildInputs = [ pkgs.xorg.libX11 ];
    # propagatedBuildInputs = [py.xkbgroup];
  };
  layout-xkbswitch.propagatedBuildInputs = [ pkgs.xkb-switch ];
  # python3Packages.xkbgroup is unpackaged
  # NOTE: Yes, there is also a plugin named `layout-xkb` with a dash.
  layout_xkb = {
    buildInputs = [ pkgs.xorg.libX11 ];
    # propagatedBuildInputs = [python3Packages.xkbgroup];
  };
  # NOTE: Yes, there is also a plugin named `layout-xkbswitch` with a dash.
  layout_xkbswitch.propagatedBuildInputs = [ pkgs.xkb-switch ];
  libvirtvms.propagatedBuildInputs = [ py.libvirt ];
  load.propagatedBuildInputs = [ pkgs.gnome-system-monitor ];
  memory.propagatedBuildInputs = [ pkgs.gnome-system-monitor ];
  messagereceiver = { };
  mocp.propagatedBuildInputs = [ pkgs.moc ];
  mpd.propagatedBuildInputs = [ pkgs.mpc ];
  network.propagatedBuildInputs = [
    py.netifaces
    pkgs.iw
  ];
  network_traffic.propagatedBuildInputs = [ py.netifaces ];
  nic.propagatedBuildInputs = [
    py.netifaces
    pkgs.iw
  ];
  notmuch_count.propagatedBuildInputs = [ pkgs.notmuch ];
  # nvidian-smi is unpackaged
  # nvidiagpu.propagatedBuildInputs = [nvidia-smi];
  octoprint.propagatedBuildInputs = [ py.tkinter ];
  # optimus-manager is unpackaged
  # optman.propagatedBuildInputs = [optimus-manager];
  pacman.propagatedBuildInputs = [
    pkgs.fakeroot
    pkgs.pacman
  ];
  pamixer.propagatedBuildInputs = [ pkgs.pamixer ];
  persian_date.propagatedBuildInputs = [ py.jdatetime ];
  pihole = { };
  ping.propagatedBuildInputs = [ pkgs.iputils ];
  pipewire.buildInputs = [ pkgs.wireplumber ];
  playerctl.propagatedBuildInputs = [ pkgs.playerctl ];
  pomodoro = { };
  # emerge is unpackaged
  # portage_status.propagatedBuildInputs = [emerge];
  # prime-select is unpackaged
  # prime.propagatedBuildInputs = [prime-select];
  progress.propagatedBuildInputs = [ pkgs.progress ];
  publicip.propagatedBuildInputs = [ py.netifaces ];
  # Deprecated in favor of pulsectl
  # pulseaudio = {};
  pulsectl.propagatedBuildInputs = [ pkgs.pulsectl ];
  redshift.propagatedBuildInputs = [ pkgs.redshift ];
  # rofication is unpackaged
  # rofication.propagatedBuildInputs = [rofication];
  rotation.propagatedBuildInputs = [ pkgs.xorg.xrandr ];
  rss = { };
  sensors.propagatedBuildInputs = [ pkgs.lm_sensors ];
  sensors2.propagatedBuildInputs = [ pkgs.lm_sensors ];
  shell = { };
  shortcut = { };
  smartstatus.propagatedBuildInputs = [ pkgs.smartmontools ];
  solaar.propagatedBuildInputs = [ pkgs.solaar ];
  spaceapi.propagatedBuildInputs = [ py.requests ];
  spacer = { };
  speedtest.propagatedBuildInputs = [ py.speedtest-cli ];
  spotify.propagatedBuildInputs = [ py.dbus-python ];
  stock = { };
  # suntime is not packaged yet
  # sun.propagatedBuildInputs = [ py.requests python-dateutil suntime ];
  system.propagatedBuildInputs = [ py.tkinter ];
  taskwarrior.propagatedBuildInputs = [ py.taskw ];
  test = { };
  thunderbird = { };
  time = { };
  timetz = { };
  title.propagatedBuildInputs = [ py.i3ipc ];
  todo = { };
  todo_org = { };
  todoist.propagatedBuildInputs = [ py.requests ];
  traffic = { };
  # Needs `systemctl`
  twmn.propagatedBuildInputs = [ ];
  uptime = { };
  usage.propagatedBuildInputs = [
    py.sqlite
    pkgs.activitywatch
  ];
  vault.propagatedBuildInputs = [ pkgs.pass ];
  vpn.propagatedBuildInputs = [
    py.tkinter
    pkgs.networkmanager
  ];
  wakatime.propagatedBuildInputs = [ py.requests ];
  watson.propagatedBuildInputs = [ pkgs.watson ];
  weather.propagatedBuildInputs = [ py.requests ];
  xkcd = { };
  # i3 is optional
  xrandr.propagatedBuildInputs = [ pkgs.xorg.xrandr ];
  yubikey.propagatedBuildInputs = [ pkgs.yubico ];
  zpool = { };
}
