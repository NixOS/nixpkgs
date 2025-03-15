{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
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
  killall,
  locale,
  netcat,
  nettools,
  pihole-ftl,
  procps,
  ncurses,
  util-linux,
  resholve,
  sqlite,
  libidn2,
  systemd,
  stateDir ? "/etc/pihole",
  ...
}:

(resholve.mkDerivation rec {
  pname = "pihole";
  version = "5.18.3";

  src = fetchFromGitHub {
    owner = "pi-hole";
    repo = "pi-hole";
    rev = "v${version}";
    hash = "sha256-F17Ewld4q3w3817DkdBufg6RHjaCK6q+0bZgmD9dbJg=";
  };

  patches = [
    ./0001-NixOS-support.patch
    ./0002-Patch-and-remove-unsupported-commands.patch
    ./0003-Add-DONT_RESTART_FTL-option.patch
    ./0004-Remove-cyclical-and-unnecessary-sourcing.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    readonly scriptsDir=$out/usr/share/pihole
    mkdir -p $scriptsDir

    # The installation script is sourced by advanced/Scripts/webpage.sh
    cp --parents -r -t $scriptsDir/ 'automated install/' advanced/{Scripts,Templates}/

    mkdir -p $out/bin

    cp -t $out/bin pihole

    cp -t $scriptsDir/advanced/Scripts gravity.sh
    chmod +x $scriptsDir/advanced/Scripts/gravity.sh

    installShellCompletion --bash --name pihole.bash \
      advanced/bash-completion/pihole

    runHook postInstall
  '';

  solutions =
    let
      out = builtins.placeholder "out";
      scriptsDir = "${out}/usr/share/pihole/advanced/Scripts";
    in
    rec {
      default = {
        scripts = [
          "bin/pihole"
          "usr/share/pihole/advanced/Scripts/gravity.sh"
          "usr/share/pihole/advanced/Scripts/list.sh"
          "usr/share/pihole/advanced/Scripts/pihole-reenable.sh"
          "usr/share/pihole/advanced/Scripts/piholeARPTable.sh"
          "usr/share/pihole/advanced/Scripts/piholeCheckout.sh"
          "usr/share/pihole/advanced/Scripts/piholeDebug.sh"
          "usr/share/pihole/advanced/Scripts/piholeLogFlush.sh"
          "usr/share/pihole/advanced/Scripts/query.sh"
          "usr/share/pihole/advanced/Scripts/update.sh"
          "usr/share/pihole/advanced/Scripts/updatecheck.sh"
          "usr/share/pihole/advanced/Scripts/utils.sh"
          "usr/share/pihole/advanced/Scripts/version.sh"
          "usr/share/pihole/advanced/Scripts/webpage.sh"
          "usr/share/pihole/advanced/Scripts/database_migration/gravity-db.sh"
        ];
        interpreter = lib.getExe bash;
        inputs = [
          # TODO: see if these inputs can help resholving
          "bin"
          "usr/share/pihole/advanced/Scripts"

          bash
          coreutils
          curl
          dig
          gawk
          getent
          gnugrep
          gnused
          iproute2
          killall
          libidn2
          locale
          ncurses
          netcat
          nettools
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
            "jq"
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
          "$PI_HOLE_FILES_DIR" = [ "${out}/usr/share/pihole" ];
          "$PI_HOLE_INSTALL_DIR" = [ scriptsDir ];
          "$PI_HOLE_LOCAL_REPO" = [ "${out}/usr/share/pihole" ];
          "$PI_HOLE_SCRIPT_DIR" = [ scriptsDir ];
          "$colfile" = [ "${scriptsDir}/COL_TABLE" ];
          "$coltable" = [ "${scriptsDir}/COL_TABLE" ];
          "$PIHOLE_COLTABLE_FILE" = [ "${scriptsDir}/COL_TABLE" ];
          "$utilsfile" = [ "${scriptsDir}/utils.sh" ];
          "$piholeGitDir" = [ "${out}/usr/share/pihole" ];
          "$PIHOLE_COMMAND" = [ "pihole" ];
        };
        keep = {
          source = [
            "$pihole_FTL" # Global config file
            "$setupVars" # Global config file
            "$PIHOLE_SETUP_VARS_FILE"
            "$versionsfile" # configuration file, doesn't exist on NixOS
            "${out}/usr/share/pihole/automated install/basic-install.sh"
            "${scriptsDir}/COL_TABLE"
            "${scriptsDir}/database_migration/gravity-db.sh"
            "${scriptsDir}/gravity.sh"
            "${scriptsDir}/piholeCheckout.sh"
            "${scriptsDir}/utils.sh"
            "${scriptsDir}/webpage.sh"
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
          "${scriptsDir}/chronometer.sh" = true;
          "${scriptsDir}/gravity.sh" = true;
          "${scriptsDir}/list.sh" = true;
          "${scriptsDir}/pihole-reenable.sh" = true;
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
          "'${out}/usr/share/pihole/automated\\ install/basic-install.sh'" = true;
          "'${out}/usr/share/pihole/automated install/basic-install.sh'" = true;

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
      # The chronometer script defines a function called pihole-FTL. If this
      # script is processed in the same solution as the others, resholve
      # doesn't fix other uses of pihole-FTL which actually refer to the
      # executable. Resholve appears to merge the scopes of all the scripts in
      # the same solution, assuming every reference to pihole-FTL is the
      # bash function.
      chronometer = default // {
        scripts = [ "usr/share/pihole/advanced/Scripts/chronometer.sh" ];
      };
    };

  meta = {
    description = "A black hole for Internet advertisements";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ williamvds ];
    platforms = lib.platforms.linux;
    mainProgram = "pihole";
  };

  passthru = {
    stateDir = stateDir;
  };
}).overrideAttrs
  (old: {
    # Resholve can't fix the hardcoded absolute paths, so substitute them before resholving
    preFixup =
      ''
        scriptsDir=$out/usr/share/pihole

        substituteInPlace $out/bin/pihole $scriptsDir/advanced/Scripts/*.sh \
          --replace-quiet /etc/.pihole $scriptsDir \
          --replace-quiet /opt/pihole $scriptsDir/advanced/Scripts
      ''
      + old.preFixup;
  })
