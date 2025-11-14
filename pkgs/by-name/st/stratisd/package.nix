{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  pkg-config,
  asciidoc,
  ncurses,
  glibc,
  dbus,
  cryptsetup,
  util-linux,
  lvm2,
  python3,
  systemd,
  xfsprogs,
  thin-provisioning-tools,
  clevis,
  jose,
  jq,
  curl,
  tpm2-tools,
  coreutils,
  udevCheckHook,
  clevisSupport ? false,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "stratisd";
  version = "3.8.6";

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = "stratisd";
    tag = "stratisd-v${version}";
    hash = "sha256-Kky/6sgvA8NDDGLQLS3sjPJWTCxkoTP/ow+netnK6tY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-zA+GEKmg5iV1PaGh0yjNb4h52PH7PwpN53xLV8P9Gac=";
  };

  postPatch = ''
    substituteInPlace udev/61-stratisd.rules \
      --replace-fail stratis-base32-decode "$out/lib/udev/stratis-base32-decode" \
      --replace-fail stratis-str-cmp       "$out/lib/udev/stratis-str-cmp"

    substituteInPlace systemd/stratis-fstab-setup \
      --replace-fail stratis-min           "$out/bin/stratis-min" \
      --replace-fail systemd-ask-password  "${systemd}/bin/systemd-ask-password" \
      --replace-fail sleep                 "${coreutils}/bin/sleep" \
      --replace-fail udevadm               "${systemd}/bin/udevadm"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    pkg-config
    asciidoc
    ncurses # tput
    udevCheckHook
  ];

  buildInputs = [
    glibc
    glibc.static
    dbus
    cryptsetup
    util-linux
    systemd
    lvm2
    (python3.withPackages (ps: [ ps.dbus-python ]))
  ];

  outputs = [
    "out"
    "initrd"
  ];

  env.EXECUTABLES_PATHS = lib.makeBinPath (
    [
      xfsprogs
      thin-provisioning-tools
    ]
    ++ lib.optionals clevisSupport [
      clevis
      jose
      jq
      cryptsetup
      curl
      tpm2-tools
      coreutils
    ]
  );

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "INSTALL=install"
  ];
  buildFlags = [ "build-all" ];

  doCheck = true;
  checkTarget = "test";

  doInstallCheck = true;

  # remove files for supporting dracut
  postInstall = ''
    mkdir -p "$initrd/bin"
    cp "$out/lib/dracut/modules.d/50stratis/stratis-rootfs-setup" "$initrd/bin"
    mkdir -p "$initrd/lib/systemd/system"
    substitute "$out/lib/dracut/modules.d/50stratis/stratisd-min.service" \
      "$initrd/lib/systemd/system/stratisd-min.service" \
      --replace-fail mkdir "${coreutils}/bin/mkdir"
    mkdir -p "$initrd/lib/udev/rules.d"
    cp udev/61-stratisd.rules "$initrd/lib/udev/rules.d"
    rm -r "$out/lib/dracut"
    rm -r "$out/lib/systemd/system-generators"
  '';

  passthru.tests = nixosTests.stratis // {
    inherit (nixosTests.installer-systemd-stage-1) stratisRoot;
  };

  meta = with lib; {
    description = "Easy to use local storage management for Linux";
    homepage = "https://stratis-storage.github.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" ];
  };
}
