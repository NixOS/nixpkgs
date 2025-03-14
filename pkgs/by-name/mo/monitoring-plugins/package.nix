{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  runCommand,
  coreutils,
  gnugrep,
  gnused,
  lm_sensors,
  net-snmp,
  openssh,
  openssl,
  perl,
  dnsutils,
  libdbi,
  libmysqlclient,
  uriparser,
  zlib,
  openldap,
  procps,
  runtimeShell,
  unixtools,
}:

let
  binPath = lib.makeBinPath [
    (placeholder "out")
    "/run/wrappers"
    coreutils
    gnugrep
    gnused
    lm_sensors
    net-snmp
    procps
  ];

  mailq = runCommand "mailq-wrapper" { preferLocalBuild = true; } ''
    mkdir -p $out/bin
    ln -s /run/wrappers/bin/sendmail $out/bin/mailq
  '';
in
stdenv.mkDerivation rec {
  pname = "monitoring-plugins";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "monitoring-plugins";
    repo = "monitoring-plugins";
    rev = "v${version}";
    hash = "sha256-T37t0shhC+8k7CN/hIOxsskuuCi0LwQui8xyRTC+pjQ=";
  };

  # TODO: Awful hack. Grrr...
  # Anyway the check that configure performs to figure out the ping
  # syntax is totally impure, because it runs an actual ping to
  # localhost (which won't work for ping6 if IPv6 support isn't
  # configured on the build machine).
  #
  # --with-ping-command needs to be done here instead of in
  # configureFlags due to the spaces in the argument
  postPatch = ''
    sed -i configure.ac \
      -e 's|^DEFAULT_PATH=.*|DEFAULT_PATH=\"${binPath}\"|'

    configureFlagsArray+=(
      --with-ping-command='${lib.getBin unixtools.ping}/bin/ping -4 -n -U -w %d -c %d %s'
      --with-ping6-command='${lib.getBin unixtools.ping}/bin/ping -6 -n -U -w %d -c %d %s'
    )
  '';

  configureFlags = [
    "--libexecdir=${placeholder "out"}/bin"
    "--with-mailq-command=${mailq}/bin/mailq"
    "--with-sudo-command=/run/wrappers/bin/sudo"
  ];

  buildInputs = [
    dnsutils
    libdbi
    libmysqlclient
    net-snmp
    openldap
    # TODO: make openssh a runtime dependency only
    openssh
    openssl
    perl
    procps
    uriparser
    zlib
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Official monitoring plugins for Nagios/Icinga/Sensu and others";
    homepage = "https://www.monitoring-plugins.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      thoughtpolice
      relrod
    ];
    platforms = platforms.linux;
  };
}
