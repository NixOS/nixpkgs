{
  lib,
  resholve,
  fetchFromGitLab,
  asciidoc,
  bash,
  coreutils,
  gawk,
  gnugrep,
  gnum4,
  gnused,
  pacman,
  util-linux,
  chrootPath ? [
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/bin"
    "/usr/bin/site_perl"
    "/usr/bin/vendor_perl"
    "/usr/bin/core_perl"
  ],
  chrootSetprivPath ? "/usr/bin/setpriv",
}:

resholve.mkDerivation rec {
  pname = "arch-install-scripts";
  version = "31";

  src = fetchFromGitLab {
    domain = "gitlab.archlinux.org";
    owner = "archlinux";
    repo = "arch-install-scripts";
    tag = "v${version}";
    hash = "sha256-Oh1nC/gPJDDy8cXiZPbEfpwOuO+RFRcxVCZuTtB2MV8=";
  };

  nativeBuildInputs = [
    asciidoc
    gnum4
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail "PREFIX = /usr/local" "PREFIX ?= /usr/local"

    substituteInPlace ./pacstrap.in \
      --replace-fail "cp -a" "cp -LR --no-preserve=mode" \
      --replace-fail "unshare pacman" "unshare ${pacman}/bin/pacman" \
      --replace-fail '"$gpg_dir" "$newroot/$gpg_dir"' '"$gpg_dir" "$newroot/$gpg_dir" && chmod 700 "$newroot/etc/pacman.d/gnupg"'

    echo "export PATH=${lib.strings.makeSearchPath "" chrootPath}:\$PATH" >> ./common
    substituteInPlace ./arch-chroot.in \
      --replace-fail "sd_args+=(setpriv" "sd_args+=(${chrootSetprivPath}"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  solutions = {
    # Give each solution a short name. This is what you'd use to
    # override its settings, and it shows in (some) error messages.
    profile = {
      # the only *required* arguments are the 3 below

      # Specify 1 or more $out-relative script paths. Unlike many
      # builders, resholve.mkDerivation modifies the output files during
      # fixup (to correctly resolve in-package sourcing).
      scripts = [
        "bin/arch-chroot"
        "bin/genfstab"
        "bin/pacstrap"
      ];

      # "none" for no shebang, "${bash}/bin/bash" for bash, etc.
      interpreter = "${bash}/bin/bash";

      # packages resholve should resolve executables from
      inputs = [
        coreutils
        gawk
        gnugrep
        gnused
        pacman
        util-linux
      ];

      execer = [
        "cannot:${pacman}/bin/pacman-conf"
        "cannot:${pacman}/bin/pacman-key"
      ];

      fake.external = [
        "systemd-escape"
        "systemd-run"
      ];

      # Avoid using setuid wrappers
      fix = {
        mount = true;
        umount = true;
      };

      keep = [
        "$setup"
        "$pid_unshare"
        "$mount_unshare"
        "$sd_args"
        "${pacman}/bin/pacman"
      ];
    };
  };

  meta = with lib; {
    description = "Useful scripts for installing Arch Linux";
    longDescription = ''
      A small suite of scripts aimed at automating some menial tasks when installing Arch Linux.
    '';
    homepage = "https://github.com/archlinux/arch-install-scripts";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ samlukeyes123 ];
    platforms = platforms.linux;
  };
}
