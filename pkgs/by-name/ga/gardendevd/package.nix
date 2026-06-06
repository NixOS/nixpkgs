{
  lib,
  stdenv,
  fetchFromCodeberg,
  nix-update-script,
  acl,
  elogind,
  meson,
  ninja,
  pkg-config,
  util-linux,
  kmod,
  uaccessSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gardendevd";
  version = "0.2";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Gardenhouse";
    repo = "gardendevd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aEG2QIRFH3F5tXBD1U+6SNmOpUMHgdhH7AXwyGGrilI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = lib.optionals uaccessSupport [
    acl
    elogind
  ];

  mesonFlags = [
    "-Dopenrc=disabled"
    "-Dmdevd=enabled"
    (lib.mesonEnable "uaccess" uaccessSupport)
  ];

  postPatch = ''
    substituteInPlace src/rules-builtin.c \
      --replace-fail "/sbin/blkid" "${util-linux}/bin/blkid" \
      --replace-fail "/sbin/modprobe" "${kmod}/bin/modprobe"
    substituteInPlace src/rules-parse.c \
      --replace-fail "/usr/lib/udev/rules.d" "$out/lib/udev/rules.d"
    substituteInPlace src/spawn.c \
      --replace-fail "/usr/lib/udev/" "$out/lib/udev/"

    patchShebangs scripts/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://codeberg.org/Gardenhouse/gardendevd";
    description = "Udev daemon running on top of mdevd to replace systemd-udev";
    longDescription = ''
      Gardendevd is a udev-compatible daemon that processes device
      events from the Linux kernel. It is designed to be a lightweight
      and flexible alternative to systemd-udevd, leveraging mdevd for
      device node creation and firmware loading.
    '';
    maintainers = with lib.maintainers; [
      aanderse
      choco98
    ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
