{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # https://github.com/systemd/systemd/pull/9318
  services.udev.extraHwdb = ''
    # Purism Librem 13 V3
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svnPurism*:pn*Librem13v3*:pvr*
     KEYBOARD_KEY_56=backslash
  '';
}
