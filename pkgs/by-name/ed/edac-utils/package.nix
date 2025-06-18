{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  sysfsutils,
  dmidecode,
  kmod,
}:

stdenv.mkDerivation {
  pname = "edac-utils";
  version = "unstable-2023-01-30";

  src = fetchFromGitHub {
    owner = "grondo";
    repo = "edac-utils";
    rev = "8fdc1d40e30f65737fef6c3ddcd1d2cd769f6277";
    hash = "sha256-jZGRrZ1sa4x0/TBJ5GsNVuWakmPNOU+oiOoXdhARunk=";
  };

  # Hard-code program paths instead of using PATH lookups. Also, labels.d and
  # mainboard are for user-configurable data, so do not look for them in Nix
  # store.
  dmidecodeProgram = lib.getExe' dmidecode "dmidecode";
  modprobeProgram = lib.getExe' kmod "modprobe";
  postPatch = ''
    substituteInPlace src/util/edac-ctl.in \
      --replace-fail 'find_prog ("dmidecode")' "\"$dmidecodeProgram\"" \
      --replace-fail 'find_prog ("modprobe")  or exit (1)' "\"$modprobeProgram\"" \
      --replace-fail '"$sysconfdir/edac/labels.d"' '"/etc/edac/labels.d"' \
      --replace-fail '"$sysconfdir/edac/mainboard"' '"/etc/edac/mainboard"'
  '';

  # NB edac-utils needs Perl for configure script, but also edac-ctl program is
  # a Perl script. Perl from buildInputs is used by patchShebangsAuto in
  # fixupPhase to update the hash bang line.
  strictDeps = true;
  nativeBuildInputs = [ perl ];
  buildInputs = [
    perl
    sysfsutils
  ];

  installFlags = [
    "sbindir=${placeholder "out"}/bin"
  ];

  # SysV init script is not relevant.
  postInstall = ''
    rm -r "$out"/etc/init.d
  '';

  meta = with lib; {
    homepage = "https://github.com/grondo/edac-utils";
    description = "Handles the reporting of hardware-related memory errors";
    mainProgram = "edac-util";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
