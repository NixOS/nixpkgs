{
  acl,
  bash,
  cockpit,
  coreutils,
  fetchFromGitHub,
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
  samba,
  shadow,
  smartmontools,
  stdenv,
  su,
  systemd,
  util-linux,
  yarn-berry,
  zfs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cockpit-zfs";
  version = "1.2.12-2";

  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "cockpit-zfs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-oeXSOxogfAazRsKfngq2+DOyo//wRJQSqm7gaCza4WY=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-YnR1SqBGnxEQaGUGMNTHHEGcOIhuGbWnqMdr4eRGXcA=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    jq
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  passthru.cockpitPath = [
    acl
    bash
    coreutils
    getent
    glibc
    iproute2
    lsscsi
    mbuffer
    msmtp
    nodejs
    openssh
    samba
    shadow
    smartmontools
    su
    systemd
    util-linux
    zfs
    cockpit.passthru.python3Packages.pyudev
    cockpit.passthru.python3Packages.py-libzfs
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
          --set PYTHONPATH "/etc/cockpit/${cockpit.passthru.python3Packages.python.sitePackages}" \
          --set PATH "${
            lib.makeBinPath [
              "/etc/cockpit"
              coreutils
              bash
              jq
            ]
          }"
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
    maintainers = [ lib.maintainers.eymeric ];
  };
})
