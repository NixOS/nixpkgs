{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  # Required
  aircrack-ng,
  bash,
  coreutils-full,
  gawk,
  gnugrep,
  gnused,
  iproute2,
  iw,
  pciutils,
  procps,
  tmux,
  # X11 Front
  xterm,
  xorg,
  # what the author calls "Internals"
  usbutils,
  wget,
  ethtool,
  util-linux,
  ccze,
  # Optionals
  # Missing in nixpkgs: beef, hostapd-wpe
  asleap,
  bettercap,
  bully,
  crunch,
  dnsmasq,
  ettercap,
  hashcat,
  hcxdumptool,
  hcxtools,
  hostapd,
  john,
  lighttpd,
  mdk4,
  nftables,
  openssl,
  pixiewps,
  reaverwps-t6x, # Could be the upstream version too
  wireshark-cli,
  # Undocumented requirements (there is also ping)
  apparmor-bin-utils,
  curl,
  glibc,
  ncurses,
  networkmanager,
  systemd,
  # Support groups
  supportWpaWps ? true, # Most common use-case
  supportHashCracking ? false,
  supportEvilTwin ? false,
  supportX11 ? false, # Allow using xterm instead of tmux, hard to test
}:
let
  deps = [
    aircrack-ng
    bash
    coreutils-full
    curl
    gawk
    glibc
    gnugrep
    gnused
    iproute2
    iw
    networkmanager
    ncurses
    pciutils
    procps
    tmux
    usbutils
    wget
    ethtool
    util-linux
    ccze
    systemd
  ]
  ++ lib.optionals supportWpaWps [
    bully
    pixiewps
    reaverwps-t6x
  ]
  ++ lib.optionals supportHashCracking [
    asleap
    crunch
    hashcat
    hcxdumptool
    hcxtools
    john
    wireshark-cli
  ]
  ++ lib.optionals supportEvilTwin [
    bettercap
    dnsmasq
    ettercap
    hostapd
    lighttpd
    openssl
    mdk4
    nftables
    apparmor-bin-utils
  ]
  ++ lib.optionals supportX11 [
    xterm
    xorg.xset
    xorg.xdpyinfo
  ];
in
stdenv.mkDerivation rec {
  pname = "airgeddon";
  version = "11.52";

  src = fetchFromGitHub {
    owner = "v1s1t0r1sh3r3";
    repo = "airgeddon";
    tag = "v${version}";
    hash = "sha256-FQB348wOXi89CnjS32cwZwTewjkguTbhK5Izvh/74Q0=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];

  # What these replacings do?
  # - Disable the auto-updates (we'll run from a read-only directory);
  # - Silence the checks (NixOS will enforce the PATH, it will only see the tools as we listed);
  # - Use "tmux", we're not patching XTerm commands;
  # - Remove PWD and $0 references, forcing it to use the paths from store;
  # - Force our PATH to all tmux sessions.
  postPatch = ''
    patchShebangs airgeddon.sh
    sed -i '
      s|AIRGEDDON_AUTO_UPDATE=true|AIRGEDDON_AUTO_UPDATE=false|
      s|AIRGEDDON_SILENT_CHECKS=false|AIRGEDDON_SILENT_CHECKS=true|
      s|AIRGEDDON_WINDOWS_HANDLING=xterm|AIRGEDDON_WINDOWS_HANDLING=tmux|
      ' .airgeddonrc

    sed -Ei '
      s|\$\(pwd\)|${placeholder "out"}/share/airgeddon;scriptfolder=${placeholder "out"}/share/airgeddon/|
      s|\$\{0\}|${placeholder "out"}/bin/airgeddon|
      s|tmux send-keys -t "([^"]+)" "|tmux send-keys -t "\1" "export PATH=\\"$PATH\\"; |
      ' airgeddon.sh
  '';

  # ATTENTION: No need to chdir around, we're removing the occurrences of "$(pwd)"
  postInstall = ''
    wrapProgram $out/bin/airgeddon --prefix PATH : ${lib.makeBinPath deps}
  '';

  # Install only the interesting files
  installPhase = ''
    runHook preInstall
    install -Dm 755 airgeddon.sh "$out/bin/airgeddon"
    install -dm 755 "$out/share/airgeddon"
    cp -dr .airgeddonrc known_pins.db language_strings.sh plugins/ "$out/share/airgeddon/"
    runHook postInstall
  '';

  meta = {
    description = "Multi-use TUI to audit wireless networks";
    mainProgram = "airgeddon";
    homepage = "https://github.com/v1s1t0r1sh3r3/airgeddon";
    changelog = "https://github.com/v1s1t0r1sh3r3/airgeddon/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
