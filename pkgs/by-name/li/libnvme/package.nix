{
  fetchFromGitHub,
  testers,
  bash,
  json_c,
  keyutils,
  lib,
  meson,
  ninja,
  openssl,
  perl,
  pkg-config,
  python3,
  stdenv,
  swig,
  systemd,
  # ImportError: cannot import name 'mlog' from 'mesonbuild'
  withDocs ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,

  # for passthru.tests
  networkmanager,
  nvme-cli,
  libblockdev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnvme";
  version = "1.16.2";


  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocs [ "man" ];

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "libnvme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M+SkxzNrRSBu5EmdK82Qh8MPDqGO7fKbdrU9irScARY=";
  };

  postPatch = ''
    patchShebangs scripts
    substituteInPlace test/sysfs/tree-diff.sh test/config/config-diff.sh \
      --replace-fail /bin/bash ${bash}/bin/bash
  '';

  nativeBuildInputs = [
    meson
    ninja
    perl # for kernel-doc
    pkg-config
    python3.pythonOnBuildForHost
    swig
  ];

  buildInputs = [
    keyutils
    json_c
    openssl
    systemd
  ];

  mesonFlags =
    lib.mapAttrsToList lib.mesonEnable {
      python = false;
      openssl = true;
      libdbus = false;
      json-c = true;
      keyutils = true;
      liburing = false;
    }
    ++ lib.mapAttrsToList lib.mesonBool {
      tests = finalAttrs.finalPackage.doCheck;
      docs-build = withDocs;
      examples = false;
    }
    ++ [ (lib.mesonOption "docs" "man") ];

  preConfigure = ''
    export KBUILD_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH)"
  '';

  # mocked ioctl conflicts with the musl one: https://github.com/NixOS/nixpkgs/pull/263768#issuecomment-1782877974
  doCheck = !stdenv.hostPlatform.isMusl;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    inherit networkmanager nvme-cli libblockdev;
  };

  meta = {
    description = "C Library for NVM Express on Linux";
    homepage = "https://github.com/linux-nvme/libnvme";
    changelog = "https://github.com/linux-nvme/libnvme/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ vifino ];
    license = with lib.licenses; [ lgpl21Plus ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "libnvme"
      "libnvme-mi"
    ];
  };
})
