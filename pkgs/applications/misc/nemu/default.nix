{ stdenv, config, lib, fetchFromGitHub
, cmake
, pkg-config
, gettext
, libpthreadstubs
, udev
, libusb1
, ncurses
, qemu
, sqlite

, libxml2
, libarchive
, graphviz
, dbus

, debugBuild ? false
, ovfSupport ? true
, saveVMSupport ? false  # requires patched version of QEMU, override them all if needed
, withVNCClientSupport ? true
, withSpice ? true
, withNetworkMap ? false
, withDbus ? false
}:

stdenv.mkDerivation rec {
  pname = "nemu";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "nemuTUI";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wbx2g7nizczrsrv4xaqm7ma1dd7m35dkhjcgczzh1z14gdpz4gw";
  };

  system.requiredKernelConfig = with config.lib.kernelConfig; [
    (isEnabled "VETH")
    (isEnabled "MACVTAP")
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    gettext
    libarchive
    libpthreadstubs
    udev
    libusb1
    libxml2
    ncurses
    qemu
    sqlite
  ] ++ lib.optional withNetworkMap graphviz
    ++ lib.optional withDbus dbus;

  cmakeFlags = lib.optional debugBuild "-DNM_DEBUG=ON"
    ++ lib.optional ovfSupport "-DNM_WITH_OVF_SUPPORT=ON"
    ++ lib.optional saveVMSupport "-DNM_SAVEVM_SNAPSHOTS=ON"
    ++ lib.optional withVNCClientSupport "-DNM_WITH_VNC_CLIENT=ON"
    ++ lib.optional withSpice "-DNM_WITH_SPICE=ON"
    ++ lib.optional withNetworkMap "-DNM_WITH_NETWORK_MAP=ON"
    ++ lib.optional withDbus "-DNM_WITH_DBUS=ON";

  preConfigure = ''
    patchShebangs .
    substituteInPlace CMakeLists.txt --replace 'USR_PREFIX "/usr"' "USR_PREFIX \"$(out)\""

    substituteInPlace src/nm_cfg_file.c --replace /bin/false /run/current-system/sw/bin/false

    substituteInPlace src/nm_cfg_file.c --replace /share/nemu/templates/config/nemu.cfg.sample \
                                                  $out/share/nemu/templates/config/nemu.cfg.sample

    substituteInPlace src/nm_cfg_file.c --replace \
'            nm_str_format(&qemu_bin, "%s/bin/qemu-system-%s",
                NM_STRING(NM_USR_PREFIX), token);' \
'            nm_str_format(&qemu_bin, "/run/wrappers/bin/qemu-system-%s", token);'

    substituteInPlace src/nm_cfg_file.c --replace "/usr/bin" /run/current-system/sw/bin
    substituteInPlace src/nm_add_vm.c --replace /bin/qemu-img ${qemu}/bin/qemu-img  # 2.2.1 only

    substituteInPlace src/nm_machine.c --replace \
'    nm_str_format(&buf, "%s/bin/qemu-system-%s",
        NM_STRING(NM_USR_PREFIX), arch);' \
'    nm_str_format(&buf, "/run/wrappers/bin/qemu-system-%s", arch);'

    substituteInPlace src/nm_add_drive.c --replace /bin/qemu-img ${qemu}/bin/qemu-img
    substituteInPlace src/nm_ovf_import.c --replace /bin/qemu-img ${qemu}/bin/qemu-img
    substituteInPlace src/nm_vm_snapshot.c --replace /bin/qemu-img ${qemu}/bin/qemu-img
    substituteInPlace src/nm_vm_control.c --replace /bin/qemu-system- ${qemu}/bin/qemu-system-
    substituteInPlace nemu.cfg.sample --replace /usr/bin /run/current-system/sw/bin
    substituteInPlace lang/ru/nemu.po --replace /bin/false /run/current-system/sw/bin/false
    substituteInPlace sh/ntty --replace /usr/bin /run/current-system/sw/bin
  '';

  preInstall = ''
    install -D -m0644 -t $out/share/doc ../LICENSE
  '';

  meta = with lib; {
    homepage = "https://github.com/nemuTUI/nemu";
    description = "Ncurses UI for QEMU";
    license = licenses.bsd2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}
