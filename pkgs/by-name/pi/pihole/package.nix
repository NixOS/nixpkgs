{
  lib,
  nixosTests,
  fetchFromGitHub,
  makeBinaryWrapper,
  installShellFiles,
  bash,
  coreutils,
  curl,
  dig,
  gawk,
  getent,
  glibc,
  gnugrep,
  gnused,
  iproute2,
  jq,
  killall,
  libidn2,
  locale,
  ncurses,
  netcat,
  net-tools,
  pihole-ftl,
  procps,
  resholve,
  sqlite,
  systemd,
  util-linux,
  stateDir ? "/etc/pihole",
}:

(resholve.mkDerivation rec {
  pname = "pihole";
  version = "6.1.4";

  src = fetchFromGitHub {
    owner = "pi-hole";
    repo = "pi-hole";
    tag = "v${version}";
    hash = "sha256-2B2GUJKt4jHEjQLBx96FRuHpnLCTzE4UPDaeQvnDONc=";
  };

  patches = [
    # Remove use of sudo in the original script, prefer to use a wrapper
    ./0001-Remove-sudo.patch
    # Disable unsupported subcommands, particularly those for imperatively installing/upgrading Pi-hole
    ./0002-Remove-unsupported-commands.patch
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    readonly scriptsDir=$out/share/pihole

    install -Dm 555 -t $out/bin pihole
    install -Dm 555 -t $scriptsDir/advanced/Scripts gravity.sh

    # The installation script is sourced by advanced/Scripts/piholeARPTable.sh etc
    cp --parents -r -t $scriptsDir/ 'automated install/' advanced/{Scripts,Templates}/

    installShellCompletion --bash --name pihole.bash \
      advanced/bash-completion/pihole

    runHook postInstall
  '';

  solutions.default =
    let
      out = builtins.placeholder "out";
      scriptsDir = "${out}/share/pihole/advanced/Scripts";
    in
    {
      scripts =
        let
          relativeScripts = "share/pihole/advanced/Scripts";
        in
        [
          "bin/pihole"
          "${relativeScripts}/api.sh"
          "${relativeScripts}/database_migration/gravity-db.sh"
          "${relativeScripts}/gravity.sh"
          "${relativeScripts}/list.sh"
          "${relativeScripts}/piholeARPTable.sh"
          "${relativeScripts}/piholeCheckout.sh"
          "${relativeScripts}/piholeDebug.sh"
          "${relativeScripts}/piholeLogFlush.sh"
          "${relativeScripts}/query.sh"
          "${relativeScripts}/update.sh"
          "${relativeScripts}/updatecheck.sh"
          "${relativeScripts}/utils.sh"
          "${relativeScripts}/version.sh"
        ];
      interpreter = lib.getExe bash;
      inputs = [
        # TODO: see if these inputs can help resholving
        "bin"
        "share/pihole/advanced/Scripts"

        bash
        coreutils
        curl
        dig
        gawk
        getent
        gnugrep
        gnused
        iproute2
        jq
        killall
        libidn2
        locale
        ncurses
        netcat
        net-tools
        pihole-ftl
        procps
        sqlite
        systemd
        util-linux
      ];
      fake = {
        source = [
          "/etc/os-release"
          "/etc/pihole/versions"
          "/etc/pihole/setupVars.conf"
        ];
        external = [
          # Used by chronometer.sh to get GPU information on Raspberry Pis
          "sudo"
          "vcgencmd"
          # used by the checkout and update scripts, which are patched out
          "git"
          "getenforce"
          "firewall-cmd"
          # Conditionally used in Docker builds
          "service"
          "lighttpd"
          # Used in piholeLogFlush.sh
          "/usr/sbin/logrotate"
          # Used by teleporter in webpage.sh
          "php"
        ];
      };
      fix = {
        "$PI_HOLE_BIN_DIR" = [ "${out}/bin" ];
        "$PI_HOLE_FILES_DIR" = [ "${out}/share/pihole" ];
        "$PI_HOLE_INSTALL_DIR" = [ scriptsDir ];
        "$PI_HOLE_LOCAL_REPO" = [ "${out}/share/pihole" ];
        "$PI_HOLE_SCRIPT_DIR" = [ scriptsDir ];
        "$colfile" = [ "${scriptsDir}/COL_TABLE" ];
        "$coltable" = [ "${scriptsDir}/COL_TABLE" ];
        "$PIHOLE_COLTABLE_FILE" = [ "${scriptsDir}/COL_TABLE" ];
        "$utilsfile" = [ "${scriptsDir}/utils.sh" ];
        "$apifile" = [ "${scriptsDir}/api.sh" ];
        "$piholeGitDir" = [ "${out}/share/pihole" ];
        "$PIHOLE_COMMAND" = [ "pihole" ];
      };
      keep = {
        source = [
          "$pihole_FTL" # Global config file
          "$setupVars" # Global config file
          "$PIHOLE_SETUP_VARS_FILE"
          "$versionsfile" # configuration file, doesn't exist on NixOS
          "${out}/share/pihole/automated install/basic-install.sh"
          "${scriptsDir}/COL_TABLE"
          "${scriptsDir}/database_migration/gravity-db.sh"
          "${scriptsDir}/gravity.sh"
          "${scriptsDir}/piholeCheckout.sh"
          "${scriptsDir}/utils.sh"
          "${scriptsDir}/api.sh"
          "/etc/os-release"
          "/etc/pihole/versions"
          "/etc/pihole/setupVars.conf"
          "$cachedVersions"
        ];

        "$PIHOLE_SETUP_VARS_FILE" = true;
        "$PKG_INSTALL" = true; # System package manager, patched out
        "$PKG_MANAGER" = true; # System package manager, patched out
        "$cmd" = true; # ping or ping6
        "$program_name" = true; # alias for $1
        "$svc" = true; # dynamic restart command
        "${out}/bin/pihole" = true;
        "${scriptsDir}/api.sh" = true;
        "${scriptsDir}/gravity.sh" = true;
        "${scriptsDir}/list.sh" = true;
        "${scriptsDir}/piholeARPTable.sh" = true;
        "${scriptsDir}/piholeDebug.sh" = true;
        "${scriptsDir}/piholeLogFlush.sh" = true;
        "${scriptsDir}/query.sh" = true;
        "${scriptsDir}/uninstall.sh" = true;
        "${scriptsDir}/update.sh" = true;
        "${scriptsDir}/updatecheck.sh" = true;
        "${scriptsDir}/version.sh" = true;

        # boolean variables
        "$addmode" = true;
        "$noReloadRequested" = true;
        "$oldAvail" = true;
        "$verbose" = true;
        "$web" = true;
        "$wildcard" = true;

        # Note that this path needs to be quoted due to the whitespace.
        # TODO: raise upstream resholve issue. pihole scripts specify this path
        # both quoted and escaped. Resholve apparently requires matching the
        # literal path, so we need to provide a version with and without the
        # backslash.
        "'${out}/share/pihole/automated\\ install/basic-install.sh'" = true;
        "'${out}/share/pihole/automated install/basic-install.sh'" = true;

        "/etc/.pihole" = true; # Patched with an override
        "/etc/os-release" = true;
        "/etc/pihole/versions" = true;
        "/etc/pihole/setupVars.conf" = true;
      };
      execer = [
        "cannot:${pihole-ftl}/bin/pihole-FTL"
        "cannot:${iproute2}/bin/ip"
        "cannot:${systemd}/bin/systemctl"
        "cannot:${glibc.bin}/bin/ldd"
        "cannot:${out}/bin/pihole"
      ];
    };

  meta = {
    description = "Black hole for Internet advertisements";
    homepage = "https://pi-hole.net";
    changelog = "https://github.com/pi-hole/pi-hole/releases/tag/v${version}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ averyvigolo ];
    platforms = lib.platforms.linux;
    mainProgram = "pihole";
  };

  passthru.tests = nixosTests.pihole-ftl;

  passthru = {
    inherit stateDir;
  };
}).overrideAttrs
  (old: {
    # Resholve can't fix the hardcoded absolute paths, so substitute them before resholving
    preFixup = ''
      scriptsDir=$out/share/pihole

      substituteInPlace $out/bin/pihole $scriptsDir/advanced/Scripts/*.sh \
        --replace-quiet /etc/.pihole $scriptsDir \
        --replace-quiet /opt/pihole $scriptsDir/advanced/Scripts
    ''
    + old.preFixup;
  })
