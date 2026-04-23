{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  help2man,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  json-glib,
  libgee,
  util-linuxMinimal,
  vte,
  xapp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timeshift";
  version = "25.12.4";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "timeshift";
    tag = finalAttrs.version;
    hash = "sha256-4iK9RngcqwR0sYo9AXcTwEQ1eoPQPbAmwM5k/rcgU9s=";
  };

  postPatch = ''
    for FILE in src/Core/Main.vala src/Utility/Device.vala; do
      substituteInPlace "$FILE" \
        --replace-fail "/sbin/blkid" "${lib.getExe' util-linuxMinimal "blkid"}"
    done

    substituteInPlace ./src/Utility/IconManager.vala \
      --replace-fail "/usr/share" "$out/share"

    # Substitute app_command to look for the `timeshift-gtk` in $out.
    substituteInPlace ./src/timeshift-launcher \
      --replace-fail "app_command='timeshift-gtk'" "app_command=$out/bin/timeshift-gtk"
  '';

  nativeBuildInputs = [
    gettext
    help2man
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
    json-glib
    libgee
    vte
    xapp
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  meta = {
    description = "System restore tool for Linux";
    longDescription = ''
      TimeShift creates filesystem snapshots using rsync+hardlinks or BTRFS snapshots.
      Snapshots can be restored using TimeShift installed on the system or from Live CD or USB.
    '';
    homepage = "https://github.com/linuxmint/timeshift";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ShamrockLee
      bobby285271
    ];
  };
})
