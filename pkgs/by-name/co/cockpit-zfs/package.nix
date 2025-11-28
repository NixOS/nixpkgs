{
  acl,
  bash,
  coreutils,
  fetchFromGitHub,
  firewalld,
  getent,
  glibc,
  iproute2,
  jq,
  lib,
  lsscsi,
  makeWrapper,
  mbuffer,
  msmtp,
  nodejs,
  openssh,
  python312,
  samba,
  shadow,
  smartmontools,
  stdenv,
  su,
  systemd,
  util-linux,
  yarn-berry_4,
  zfs,
}:

let
  yarn-berry = yarn-berry_4;
  python = (
    python312.withPackages (ps: [
      ps.pyudev
      ps.py-libzfs
    ])
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cockpit-zfs";
  version = "1.2.12-2";

  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "cockpit-zfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oeXSOxogfAazRsKfngq2+DOyo//wRJQSqm7gaCza4WY=";
    fetchSubmodules = true;
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-YnR1SqBGnxEQaGUGMNTHHEGcOIhuGbWnqMdr4eRGXcA=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
    makeWrapper
  ];

  propagatedBuildInputs = [
    smartmontools
    zfs
    lsscsi
    util-linux
    coreutils
    nodejs
    bash
    systemd
    shadow
    samba
    glibc
    openssh
    mbuffer
    msmtp
    acl
    firewalld
  ];

  env = {
    # Disable post-install scripts that try to access network (electron, plantuml-pipe)
    YARN_ENABLE_SCRIPTS = "0";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  patchPhase =
    let
      # houston-common-lib has @types/electron which pulls in electron.
      # Electron's postinstall downloads binaries, which fails in sandbox.
      # Since this is a Cockpit plugin (not an Electron app), we don't need electron.
      houstonLibDir = "houston-common/houston-common-lib";
      houstonUiDir = "houston-common/houston-common-ui";
    in
    ''
      runHook prePatch

      # Remove electron type dependency
      substituteInPlace ${houstonLibDir}/package.json \
        --replace-fail '"@types/electron": "^1.6.12",' ""
      substituteInPlace ${houstonLibDir}/tsconfig.json \
        --replace-fail '"types": ["electron"]' '"types": []'

      # Skip TypeScript type checking (fails without electron types)
      substituteInPlace ${houstonLibDir}/package.json \
        --replace-fail '"build": "tsc --noEmit && vite build"' '"build": "vite build"'
      substituteInPlace ${houstonUiDir}/package.json \
        --replace-fail '"build": "run-p type-check \"build-only {@}\" --"' '"build": "vite build"'

      # Externalize vue and electron in houston-common-lib (peer dependencies)
      substituteInPlace ${houstonLibDir}/vite.config.ts \
        --replace-fail 'external: (id) => {' 'external: (id) => {
        if (id === "vue" || id.startsWith("vue/") || id === "electron" || id.startsWith("electron/")) return true;'

      # Disable VueDevTools and dts plugins (fail with Yarn PnP)
      substituteInPlace ${houstonUiDir}/vite.config.ts \
        --replace-fail "import VueDevTools from 'vite-plugin-vue-devtools'" "" \
        --replace-fail "VueDevTools()," "" \
        --replace-fail "import dts from 'vite-plugin-dts'" ""
      sed -i '/dts({/,/})/d' ${houstonUiDir}/vite.config.ts

      substituteInPlace zfs/src/composables/datasets.ts \
                        zfs/src/composables/pools.ts \
                        zfs/src/composables/snapshots.ts \
                        zfs/src/scripts/change-encrypted-key.py \
                        zfs/src/scripts/create-encrypted-dataset.py \
                        zfs/src/scripts/encryption-key-validation.py \
                        zfs/src/scripts/send-snapshot.py \
                        zfs/src/scripts/unlock-encrypted-dataset.py \
        --replace-fail "'zfs'" "'${zfs}/bin/zfs'"

      substituteInPlace houston-common/houston-common-lib/lib/managers/zfs/manager.ts \
        --replace-fail '"zfs"' '"${zfs}/bin/zfs"'

      substituteInPlace zfs/src/scripts/check-dataset.py \
                        zfs/src/scripts/check-remote-snapshots.py \
                        zfs/src/scripts/find-last-common-snap.py \
                        zfs/src/scripts/send-snapshot.py \
        --replace-fail "'ssh'" "'${openssh}/bin/ssh'"

      substituteInPlace zfs/src/scripts/send-snapshot.py \
        --replace-fail "'mbuffer'" "'${mbuffer}/bin/mbuffer'"

      substituteInPlace system_files/opt/45drives/houston/notification_utils.py \
        --replace-fail '"msmtp"' '"${msmtp}/bin/msmtp"' \
        --replace-fail '"python3"' '"${python}/bin/python3"'

      substituteInPlace zfs/src/scripts/get-disks.py \
        --replace-fail '"lsblk"' '"${util-linux}/bin/lsblk"' \
        --replace-fail '"blkid"' '"${util-linux}/bin/blkid"' \
        --replace-fail '"findmnt"' '"${util-linux}/bin/findmnt"' \
        --replace-fail '"smartctl"' '"${smartmontools}/bin/smartctl"' \
        --replace-fail '"udevadm"' '"${util-linux}/bin/udevadm"'

      substituteInPlace zfs/src/scripts/get-pools.py \
                        zfs/src/composables/disks.ts \
                        zfs/src/scripts/get-disks.py \
                        houston-common/houston-common-lib/lib/managers/zfs/manager.ts \
        --replace-fail '"zpool"' '"${zfs}/bin/zpool"'

      substituteInPlace zfs/src/composables/pools.ts \
        --replace-fail "'zpool'" "'${zfs}/bin/zpool'"

      substituteInPlace zfs/src/composables/snapshots.ts \
                        zfs/src/composables/scan.ts \
                        zfs/src/composables/helpers.ts \
                        houston-common/houston-common-lib/lib/scheduler/Scheduler.ts \
                        zfs/src/composables/datasets.ts \
                        houston-common/houston-common-lib/lib/scheduler/RemoteManager.ts \
                        zfs/src/composables/pools.ts \
        --replace-fail "'/usr/bin/env', 'python3'" "'${python}/bin/python3'"

      substituteInPlace houston-common/houston-common-lib/lib/process/Command.ts \
                        houston-common/houston-common-lib/lib/scheduler/utils/helpers.ts \
        --replace-fail '"/usr/bin/env", "python3"' '"${python}/bin/python3"'

      substituteInPlace houston-common/houston-common-lib/lib/scheduler/utils/helpers.ts \
        --replace-fail '"python3",' '"${python}/bin/python3",'

      substituteInPlace houston-common/houston-common-lib/lib/process/Command.ts \
        --replace-fail '"/usr/bin/env", "bash"' '"${bash}/bin/bash"'

      substituteInPlace zfs/src/composables/disks.ts \
      --replace-fail '"wipefs"' '"${util-linux}/bin/wipefs"'

      substituteInPlace houston-common/houston-common-lib/lib/server.ts \
        --replace-fail '"true"' '"${coreutils}/bin/true"' \
        --replace-fail '"hostname"' '"${coreutils}/bin/hostname"' \
        --replace-fail '"ip"' '"${iproute2}/bin/ip"' \
        --replace-fail '"getent"' '"${glibc}/bin/getent"' \
        --replace-fail '"groups"' '"${coreutils}/bin/groups"' \
        --replace-fail '"groupadd"' '"${shadow}/bin/groupadd"' \
        --replace-fail '"net"' '"${samba}/bin/net"' \
        --replace-fail '"reboot"' '"${systemd}/bin/reboot"'

      substituteInPlace houston-common/houston-common-lib/lib/process.test.ts \
        --replace-fail '"true"' '"${coreutils}/bin/true"' \
        --replace-fail '"false"' '"${coreutils}/bin/false"' \
        --replace-fail '"echo"' '"${coreutils}/bin/echo"' \
        --replace-fail '"printf"' '"${coreutils}/bin/printf"' \
        --replace-fail '"dd"' '"${coreutils}/bin/dd"' \
        --replace-fail '"cat"' '"${coreutils}/bin/cat"'

      substituteInPlace houston-common/houston-common-lib/lib/scheduler/TaskLog.ts \
        --replace-fail "'systemctl'" "'${systemd}/bin/systemctl'" \
        --replace-fail "'journalctl'" "'${systemd}/bin/journalctl'"

      substituteInPlace houston-common/houston-common-lib/lib/path.ts \
        --replace-fail '"test"' '"${coreutils}/bin/test"' \
        --replace-fail '"mkdir"' '"${coreutils}/bin/mkdir"' \
        --replace-fail '"touch"' '"${coreutils}/bin/touch"' \
        --replace-fail '"df"' '"${coreutils}/bin/df"' \
        --replace-fail '"realpath"' '"${coreutils}/bin/realpath"' \
        --replace-fail '"stat"' '"${coreutils}/bin/stat"' \
        --replace-fail '"chmod"' '"${coreutils}/bin/chmod"' \
        --replace-fail '"chown"' '"${coreutils}/bin/chown"' \
        --replace-fail '"getfattr"' '"${coreutils}/bin/getfattr"' \
        --replace-fail '"setfattr"' '"${coreutils}/bin/setfattr"' \
        --replace-fail '"mv"' '"${coreutils}/bin/mv"' \
        --replace-fail '"rm"' '"${coreutils}/bin/rm"' \
        --replace-fail '"cat"' '"${coreutils}/bin/cat"' \
        --replace-fail '"mktemp"' '"${coreutils}/bin/mktemp"' \
        --replace-fail '"rmdir"' '"${coreutils}/bin/rmdir"' \
        --replace-fail "'find" "'${coreutils}/bin/find"

      substituteInPlace houston-common/houston-common-lib/examples/process/throws.ts \
        --replace-fail "'rm'" "'${coreutils}/bin/rm'"

      substituteInPlace houston-common/houston-common-lib/lib/managers/samba/manager.ts \
        --replace-fail '"smbcontrol"' '"${samba}/bin/smbcontrol"'

      substituteInPlace houston-common/houston-common-lib/examples/process/output.ts \
        --replace-fail "'getent'" "'${getent}/bin/getent'" \
        --replace-fail "'passwd'" "'${su}/bin/passwd'"

      substituteInPlace houston-common/houston-common-lib/examples/process/input.ts \
        --replace-fail "'dd'" "'${coreutils}/bin/dd'"

      substituteInPlace houston-common/houston-common-lib/examples/process/allowFailure.ts \
        --replace-fail "'rm'" "'${coreutils}/bin/rm'"

      substituteInPlace houston-common/houston-common-ui/lib/composables/computedResult.ts \
        --replace-fail '"ls"' '"${coreutils}/bin/ls"'

      substituteInPlace houston-common/houston-common-lib/lib/managers/easysetup/manager.ts \
        --replace-fail '"firewall-cmd"' '"${firewalld}/bin/firewall-cmd"' \
        --replace-fail '"node"' '"${nodejs}/bin/node"' \
        --replace-fail '"bash"' '"${bash}/bin/bash"' \
        --replace-fail '"systemctl"' '"${systemd}/bin/systemctl"' \
        --replace-fail '"hostname"' '"${coreutils}/bin/hostname"' \
        --replace-fail '"rm"' '"${coreutils}/bin/rm"' \
        --replace-fail '"sshd"' '"${systemd}/bin/sshd"' \
        --replace-fail '"timedatectl"' '"${systemd}/bin/timedatectl"' \
        --replace-fail '"id"' '"${coreutils}/bin/id"' \
        --replace-fail '"mkdir"' '"${coreutils}/bin/mkdir"' \
        --replace-fail '"chmod"' '"${coreutils}/bin/chmod"' \
        --replace-fail '"touch"' '"${coreutils}/bin/touch"' \
        --replace-fail '"chown"' '"${coreutils}/bin/chown"' \
        --replace-fail '"setfacl"' '"${acl}/bin/setfacl"'

      runHook postPatch
    '';

  buildPhase = ''
    runHook preBuild

    yarn workspaces foreach -Rpt --from 'cockpit-zfs' run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cockpit/zfs
    cp -r zfs/dist/* $out/share/cockpit/zfs/

    if [ -d system_files ]; then
      cp -r system_files/* $out/
    fi

    for script in $out/etc/zfs/zed.d/*; do
      if [ -f "$script" ]; then
        wrapProgram "$script" \
          --set PATH "${coreutils}/bin:${bash}/bin:${python}/bin:${jq}/bin"
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Cockpit plugin for ZFS management by 45Drives";
    homepage = "https://github.com/45Drives/cockpit-zfs";
    changelog = "https://github.com/45Drives/cockpit-zfs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eymeric ];
  };
})
