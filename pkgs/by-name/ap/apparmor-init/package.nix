{
  lib,
  stdenv,
  which,
  replaceVars,
  perl,
  buildPackages,
  runtimeShellPackage,

  # apparmor deps
  libapparmor,
  apparmor-bin-utils,
  apparmor-parser,

  # runtime deps
  gnused,
  gnugrep,
  systemd,
  coreutils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "apparmor-init";
  inherit (libapparmor) version src;

  sourceRoot = "${finalAttrs.src.name}/init";

  patches = [
    (replaceVars ./fix-rc-apparmor-functions-FHS.patch {
      PATH = lib.makeBinPath [
        # bash script needs a bunch of binaries, but we can't wrapProgram because it is more a library that will be used with `source`
        apparmor-bin-utils
        apparmor-parser
        coreutils
        gnused
        gnugrep
        systemd
      ];
    })
  ];

  postPatch = ''
    patchShebangs .

    substituteInPlace apparmor.service \
      --replace-fail "/bin/true" "${lib.getExe' coreutils "true"}"

    # the various provided scripts hardcode /lib/apparmor
    for FILE in aa-teardown apparmor.service apparmor.systemd profile-load
    do
      substituteInPlace "$FILE" \
        --replace-fail "/lib/apparmor" "$out/lib/apparmor"
    done
  '';

  nativeBuildInputs = [
    which
    perl
  ];

  buildInputs = [
    runtimeShellPackage
  ];

  makeFlags = [
    "POD2MAN=${lib.getExe' buildPackages.perl "pod2man"}"
    "POD2HTML=${lib.getExe' buildPackages.perl "pod2html"}"
    "MANDIR=share/man"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "DISTRO=unknown"
    "USR_SBINDIR=${placeholder "out"}/bin"
    "SBINDIR=${placeholder "out"}/bin"
    "LOCALEDIR=${placeholder "out"}/share/locale"
    "SYSTEMD_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
  ];

  doCheck = true;

  installTargets = [
    "install"
    # Likely not very useful for NixOS, as this is missing some NixOS awareness such as loading declarative profiles from the store
    # However, the cost is low, it may be useful in the future or on non-NixOS systems, so install the systemd service too.
    "install-systemd"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = libapparmor.meta // {
    description = "Mandatory access control system - init files";
  };
})
