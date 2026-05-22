{
  lib,
  stdenv,
  autoPatchelfHook,
  buildFHSEnv,
  copyDesktopItems,
  icoutils,
  makeDesktopItem,
  makeWrapper,
  python3,
  requireFile,
  unzip,
  jdk,
  zulu21,
  alsa-lib,
  fontconfig,
  freetype,
  glib,
  gtk2,
  gtk3,
  krb5,
  libGL,
  libusb1,
  libxkbcommon,
  pcsclite,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  libxrandr,
  libxcursor,
  libxxf86vm,
  zlib,
}:

let
  version = "2.22.0";

  zulu21WithFx = zulu21.override { enableJavaFX = true; };

  package = stdenv.mkDerivation {
    pname = "stm32cubeprogrammer-unwrapped";
    inherit version;

    src = requireFile {
      name = "SetupSTM32CubeProgrammer_linux_64.zip";
      sha256 = "fffa017abb4da14582e129aa9a1e4f87e6d0719a3cb950c0184f4cb48ab60aa7";
      url = "https://www.st.com/en/development-tools/stm32cubeprog.html";
      message = ''
        STM32CubeProgrammer must be downloaded manually from STMicroelectronics.

        1. Visit https://www.st.com/en/development-tools/stm32cubeprog.html
        2. Download "STM32CubeProgrammer for Linux" (you may need an ST account).
        3. Add the zip to the Nix store:

           nix-store --add-fixed sha256 SetupSTM32CubeProgrammer_linux_64.zip
      '';
    };

    nativeBuildInputs = [
      autoPatchelfHook
      icoutils
      makeWrapper
      jdk
      python3
      unzip
    ];

    buildInputs = [
      alsa-lib
      fontconfig
      freetype
      glib
      gtk2
      gtk3
      krb5
      libGL
      libusb1
      libxkbcommon
      pcsclite
      zlib
      stdenv.cc.cc.lib
      libx11
      libxext
      libxi
      libxrender
      libxtst
      libxrandr
      libxcursor
      libxxf86vm
    ];

    # libcrypto.so.1.0.0 is wanted by the bundled libssl.so/libstp11_SAM.so
    # (HSM/smartcard PKCS#11 support — not needed for core flashing). Qt5
    # references are residual from older libFileManager builds.
    autoPatchelfIgnoreMissingDeps = [
      "libjvm.so"
      "libQt5Core.so.5"
      "libQt5Network.so.5"
      "libQt5SerialPort.so.5"
      "libQt5Widgets.so.5"
      "libQt5Xml.so.5"
      "libQt5Gui.so.5"
      "libcrypto.so.1.0.0"
    ];

    dontConfigure = true;

    unpackPhase = ''
      runHook preUnpack
      unzip -q $src -d unpacked
      runHook postUnpack
    '';

    buildPhase = ''
      runHook preBuild

      install_dir="$PWD/staging"

      # The .exe is an IzPack jar; the .linux ELF wrapper just invokes
      # `java -jar SetupSTM32CubeProgrammer-${version}.exe`. We drive the
      # IzPack -console installer with a small Python expect-style helper.
      cat > drive.py <<'PYEOF'
      import os, re, select, subprocess, sys, time

      install_dir, jar = sys.argv[1], sys.argv[2]
      java = os.environ["JAVA_BIN"]

      proc = subprocess.Popen(
          [java, "-jar", jar, "-console"],
          stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
          bufsize=0,
      )

      buf = b""
      last_input_at = time.time()

      def send(line):
          global last_input_at
          sys.stdout.write(f"\n--> [{line!r}]\n"); sys.stdout.flush()
          proc.stdin.write((line + "\n").encode()); proc.stdin.flush()
          last_input_at = time.time()

      rules = [
          (re.compile(rb"to continue, 2 to quit, 3 to redisplay"), lambda: "1"),
          (re.compile(rb"to accept, 2 to reject, 3 to redisplay"), lambda: "1"),
          (re.compile(rb"Select the installation path"),           lambda: install_dir),
          (re.compile(rb"Press Enter to continue, X to exit"),     lambda: ""),
          (re.compile(rb"Press anything to continue"),             lambda: ""),
          (re.compile(rb"Enter Y for Yes, N for No"),              lambda: "Y"),
          # IzPack ExecutableFile post-install script — chmod fails in
          # the sandbox (no /bin/chmod); say OK so install continues, we
          # set executable bits ourselves in installPhase.
          (re.compile(rb"Enter O for OK, C to Cancel"),            lambda: "O"),
      ]

      fd = proc.stdout.fileno()
      os.set_blocking(fd, False)

      deadline = time.time() + 1800
      while True:
          if proc.poll() is not None:
              break
          r, _, _ = select.select([fd], [], [], 1.0)
          if r:
              try:
                  chunk = os.read(fd, 4096)
              except BlockingIOError:
                  chunk = b""
              if not chunk:
                  if proc.poll() is not None:
                      break
                  continue
              sys.stdout.buffer.write(chunk); sys.stdout.flush()
              buf += chunk

              for rx, resp in rules:
                  m = rx.search(buf)
                  if m:
                      send(resp())
                      buf = buf[m.end():]
                      break

          if time.time() - last_input_at > 20 and proc.poll() is None:
              sys.stdout.write("\n!!! idle 20s, sending '1'\n")
              send("1")

          if time.time() > deadline:
              sys.stdout.write("\n!!! deadline reached\n")
              proc.kill(); break

      proc.wait()
      sys.stdout.write(f"\n=== java exited rc={proc.returncode} ===\n")
      PYEOF

      cd unpacked
      JAVA_BIN="${jdk}/bin/java" python3 -u ../drive.py \
        "$install_dir" "SetupSTM32CubeProgrammer-${version}.exe"

      if [ ! -f "$install_dir/bin/STM32_Programmer_CLI" ]; then
        echo "IzPack install did not produce expected files" >&2
        exit 1
      fi

      cd "$NIX_BUILD_TOP"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      out_root="$out/opt/STM32CubeProgrammer"
      mkdir -p "$out_root"
      cp -r "$PWD/staging"/. "$out_root"/

      # IzPack does not preserve executable bits reliably in the sandbox.
      chmod +x \
        "$out_root/bin/STM32_Programmer_CLI" \
        "$out_root/bin/STM32_KeyGen_CLI" \
        "$out_root/bin/STM32_SigningTool_CLI" \
        "$out_root/bin/STM32CubeProgrammerLauncher" \
        "$out_root/bin/STM32_Programmer.sh" \
        "$out_root/bin/STM32CubeProgrammer" || true
      find "$out_root" -name '*.so*' -exec chmod +x {} +

      mkdir -p $out/bin
      makeWrapper "$out_root/bin/STM32_Programmer_CLI" $out/bin/STM32_Programmer_CLI \
        --prefix LD_LIBRARY_PATH : "$out_root/lib"
      makeWrapper "$out_root/bin/STM32_KeyGen_CLI" $out/bin/STM32_KeyGen_CLI \
        --prefix LD_LIBRARY_PATH : "$out_root/lib"
      makeWrapper "$out_root/bin/STM32_SigningTool_CLI" $out/bin/STM32_SigningTool_CLI \
        --prefix LD_LIBRARY_PATH : "$out_root/lib"

      # Inner GUI launcher — runs inside the FHS wrapper below so /bin/bash
      # exists (the Java code Runtime.exec()s /bin/bash). zulu21 with JavaFX
      # provides the JavaFX modules the JRE 8-built launcher expects.
      makeWrapper ${zulu21WithFx}/bin/java $out/bin/.STM32CubeProgrammer-inner \
        --add-flags "-Djdk.gtk.version=3" \
        --add-flags "-jar $out_root/bin/STM32CubeProgrammerLauncher" \
        --set GDK_BACKEND x11 \
        --prefix LD_LIBRARY_PATH : "$out_root/lib"

      # udev rules for ST-LINK / J-Link / DFU
      mkdir -p $out/lib/udev/rules.d
      if [ -d "$out_root/Drivers/rules" ]; then
        for r in "$out_root"/Drivers/rules/*.rules; do
          cp "$r" "$out/lib/udev/rules.d/"
        done
      fi

      # Icon — extract each size of the bundled .ico into hicolor PNGs
      if [ -f "$out_root/util/Programmer.ico" ]; then
        icotool -x -o "$NIX_BUILD_TOP" "$out_root/util/Programmer.ico" || true
        for png in "$NIX_BUILD_TOP"/Programmer_*.png; do
          [ -f "$png" ] || continue
          size=$(basename "$png" | sed -E 's/.*_([0-9]+)x[0-9]+x[0-9]+\.png/\1/')
          [ -n "$size" ] || continue
          dest=$out/share/icons/hicolor/"$size"x"$size"/apps
          mkdir -p "$dest"
          cp "$png" "$dest/stm32cubeprogrammer.png"
        done
      fi

      runHook postInstall
    '';
  };

  desktopItem = makeDesktopItem {
    name = "stm32cubeprogrammer";
    desktopName = "STM32CubeProgrammer";
    comment = "STMicroelectronics STM32 microcontroller programming software";
    exec = "STM32CubeProgrammer";
    icon = "stm32cubeprogrammer";
    terminal = false;
    categories = [
      "Development"
      "Electronics"
      "Engineering"
    ];
    startupWMClass = "STM32CubeProgrammer";
  };

in
buildFHSEnv {
  pname = "stm32cubeprogrammer";
  inherit version;
  runScript = "${package}/bin/.STM32CubeProgrammer-inner";

  extraInstallCommands = ''
    mv $out/bin/stm32cubeprogrammer $out/bin/STM32CubeProgrammer

    for cli in STM32_Programmer_CLI STM32_KeyGen_CLI STM32_SigningTool_CLI; do
      ln -sf ${package}/bin/$cli $out/bin/$cli
    done

    mkdir -p $out/share/applications $out/share/icons $out/lib/udev
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    ln -sf ${package}/share/icons/* $out/share/icons/
    ln -sf ${package}/lib/udev/rules.d $out/lib/udev/rules.d
  '';

  targetPkgs =
    pkgs: with pkgs; [
      alsa-lib
      cairo
      dbus
      expat
      fontconfig
      freetype
      glib
      gtk3
      krb5
      libGL
      libusb1
      libxkbcommon
      pango
      pcsclite
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxtst
      libxxf86vm
      libxcursor
      udev
      zlib
    ];

  meta = {
    description = "All-in-one multi-OS software tool for programming STM32 products";
    longDescription = ''
      STM32CubeProgrammer (STM32CubeProg) is an all-in-one multi-OS software
      tool for programming STM32 products. It provides an easy-to-use and
      efficient environment for reading, writing, and verifying device
      memory through both the debug interface (JTAG and SWD) and the
      bootloader interface (UART, USB DFU, I2C, SPI, and CAN).
      STM32CubeProgrammer offers a wide range of features to program STM32
      internal memories (such as Flash, RAM, and OTP) as well as external
      memories.
    '';
    homepage = "https://www.st.com/en/development-tools/stm32cubeprog.html";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "STM32CubeProgrammer";
    maintainers = with lib.maintainers; [ beeelias ];
  };
}
