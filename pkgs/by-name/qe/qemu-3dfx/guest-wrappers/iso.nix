{
  lib,
  runCommand,
  cdrkit,
  dos2unix,
  guest-wrappers-windows,
  guest-wrappers-djgpp,
  guest-wrappers-watcom,
}:

runCommand "qemu-3dfx-guest-wrappers-iso"
  {
    nativeBuildInputs = [ cdrkit ];

    meta = {
      description = "ISO containing kjliew/qemu-3dfx guest wrappers and an INSTALL.BAT for Windows guests";
      homepage = "https://github.com/kjliew/qemu-3dfx";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ io12 ];
      platforms = lib.platforms.linux;
    };
  }
  ''
    mkdir -p root/{9X,NT,DOS,OPENGL32}

    for f in fxmemmap.vxd glide.dll glide2x.dll glide3x.dll; do
      install -m644 ${guest-wrappers-windows}/$f root/9X/"''${f^^}"
    done
    install -m644 ${guest-wrappers-watcom}/glide2x.ovl root/9X/GLIDE2X.OVL

    for f in fxptl.sys instdrv.exe glide.dll glide2x.dll glide3x.dll; do
      install -m644 ${guest-wrappers-windows}/$f root/NT/"''${f^^}"
    done

    install -m644 ${guest-wrappers-djgpp}/glide2x.dxe  root/DOS/GLIDE2X.DXE
    install -m644 ${guest-wrappers-djgpp}/glide3x.dxe  root/DOS/GLIDE3X.DXE
    install -m644 ${guest-wrappers-watcom}/glide2x.ovl root/DOS/GLIDE2X.OVL

    install -m644 ${guest-wrappers-windows}/opengl32.dll root/OPENGL32/OPENGL32.DLL
    cat > root/OPENGL32/README.TXT <<'EOF'
    Copy OPENGL32.DLL into the installation folder of each game that
    needs OpenGL. Do NOT copy it to %WINDIR%\SYSTEM (or system32) -
    that would override the OS implementation system-wide.

    If the game already has its own OPENGL32.DLL, back it up first
    (rename to OPENGL32.DLL.BAK).
    EOF
    ${dos2unix}/bin/unix2dos root/OPENGL32/README.TXT

    install -m644 ${../installer/INSTALL.BAT} root/INSTALL.BAT
    install -m644 ${../installer/README.TXT}  root/README.TXT
    ${dos2unix}/bin/unix2dos root/INSTALL.BAT
    ${dos2unix}/bin/unix2dos root/README.TXT

    mkdir -p $out
    mkisofs \
      -o $out/qemu-3dfx-wrappers.iso \
      -V QEMU3DFX \
      -J -r \
      -iso-level 1 \
      -input-charset ascii \
      root/
  ''
