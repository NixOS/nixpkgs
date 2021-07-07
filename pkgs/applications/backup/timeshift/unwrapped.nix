{ stdenv
, lib
, fetchFromGitHub
## Native build inputs
, pkg-config
, vala
, which
, gettext
## Build inputs
, vte
, cinnamon
, gtk3
, libgee
, json-glib
## Shells
, bash
}:

stdenv.mkDerivation {
  pname = "timeshift-unstable";
  version = "2020-11-30";

  src = fetchFromGitHub {
    owner = "teejee2008";
    repo = "timeshift";
    rev = "08d0e5912b617009f2f0fdb61fb4173cb3576ed4";
    sha256 = "sha256-fdCcajRKAaLGGKAhCvxsdfjtogXjJp2u0PV2P3R6yao=";
  };

  postPatch = ''
    find ./src -mindepth 1 -name "*.vala" -type f -exec sed -i 's/"\/sbin\/blkid"/"blkid"/g' {} \;
    mkdir -p $out
    substituteInPlace ./src/makefile \
        --replace "SHELL=/bin/bash" "SHELL=${bash}" \
        --replace "prefix=/usr" "prefix=$out" \
        --replace "sysconfdir=/etc" "sysconfdir=$out/etc"
    substituteInPlace ./src/Utility/IconManager.vala \
        --replace "/usr/share" "$out/share"
  '';

  buildInputs = [
    vte
    cinnamon.xapps
    gtk3
    libgee
    json-glib
  ];

  nativeBuildInputs = [
    vala
    pkg-config
    which
    gettext
  ];

  propagatedBuildInputs = [
    bash
  ];

  doCheck = true;

  # The '"'"' is to represent one single quote in single quotes strings for shell scripts
  # The tri-single quote is to represent two single quotes quoted by di-single quotes for nix expressions

  # First substitution
  # The orginal line in $out/bin/timeshift-launcher is
  # app_command='timeshift-gtk'
  # The replaced result will be
  # app_command=''"$(dirname "$(realpath "$0")")"'/timeshift-gtk'

  # Second substitution
  # The original phrase to substitute in $out/bin/timeshift-launcher is
  # pkexec ${app_command}
  # The replacement is
  # pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "${app_command}"

  postFixup = ''
    substituteInPlace "$out/bin/timeshift-launcher" \
        --replace "app_command='timeshift-gtk'" 'app_command='"'"'''"'"'"$(realpath "$(dirname "$0")")"'"'"'/timeshift-gtk'"'"'''

    substituteInPlace "$out/bin/timeshift-launcher" \
        --replace 'pkexec ''${app_command}' 'pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "''${app_command}"'
  '';

  meta = with lib; {
    description = "A system restore tool for Linux";
    longDescription = ''
      TimeShift creates filesystem snapshots using rsync+hardlinks or BTRFS snapshots.
      Snapshots can be restored using TimeShift installed on the system or from Live CD or USB.
      The main purpose of this package is to
      restore the TimeShift images of distros other than NixOS.
      NixOS comes with sophisticated ways to rollback and switch generations,
      and its own way to manage bootloaders and system cron jobs.
      To use this package to restore broken distros,
      this package can be installed on a working NixOS on USB stick or another partition,
      or on the target system or other distros through Nix package manager.
    '';
    homepage = "https://github.com/teejee2008/timeshift";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
