{ stdenv, lib, jdk, patchelf, makeWrapper, xorg, zip, unzip, rsync, fetchzip
, xdg_utils ? null, gsettings-desktop-schemas ? null }:
let
  arch = "linux64";
  libs = (with xorg; [ libXext libX11 libXrender libXtst libXi libXxf86vm ]);
  repeatString = n: str:
    lib.concatStrings (lib.lists.map (lib.range 1 n) (lib.const str));
in stdenv.mkDerivation rec {
  pname = "processing";
  version = "3.5.4";

  src = fetchzip {
    url = "https://download.processing.org/${pname}-${version}-${arch}.tgz";
    sha256 = "0fqjsa1j05wriwpa7fzvv2rxhhsz6ixqzf52syxr4z74j3wkxk8k";
  };

  nativeBuildInputs = [ patchelf makeWrapper zip unzip rsync ]
    ++ (lib.optional (xdg_utils != null) xdg_utils);
  buildInputs = [ jdk ] ++ libs;

  dontConfigure = true;

  # Suppress "Not fond of this Java VM" message box.
  # The block of code we're replacing is:
  #
  #   $ javap -v processing/app/platform/LinuxPlatform.class
  #   52: ldc           #42                 // String Not fond of this Java VM
  #   54: ldc           #44                 // String Processing requires Java 8 from Oracle. ...
  #   56: aconst_null
  #   57: invokestatic  #46                 // Method processing/app/Messages.showWarning:(
  #                                         //    Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)V
  #
  # which gets written to the .class file as the following bytes:
  #
  #     $ xxd processing/app/platform/LinuxPlatform.class
  #     00000c90: .... .... .... .... .... .... .... 122a
  #     00000ca0: 122c 01b8 002e .... .... .... .... ....
  #
  # i.e. 8 bytes starting at 0xc9e (= 3230):
  #
  #     12 2a    |  ldc 42
  #     12 2c    |  ldc 44
  #     01       |  aconst_null
  #     b8 00 2e |  invokestatic 46
  #
  # We overwrite those instructions with null bytes (`nop`) using `dd`.
  #
  # See the JVM instruction set specification:
  #     https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-6.html
  # Patching binary files with `dd`:
  #     https://stackoverflow.com/a/5586379

  notFondOfThisJVM = {
    suppressPopup = true;
    # Used by sha256sum -- can't be a base-32 Nix hash.
    linuxPlatformSHA256 =
      "b8ceb19e1c8d022f963d2abfb56abc02b5f037e32042f522e1f2663d0ee8f18d";
    classToPatch = "processing/app/platform/LinuxPlatform.class";
    bytesToOverwrite = 8;
    startOverwritingAt = 3230;
  };

  buildPhase = with notFondOfThisJVM;
    lib.optionalString suppressPopup
    (let class = lib.escapeShellArg classToPatch;
    in ''
      # `unzip` will need to make a directory named `processing`, but right now
      # that's a shell script. Move it to the side and we'll move it back when
      # we're done.
      mv processing processing-bin

      unzip lib/pde.jar ${class}

      # Make sure the extracted class has the right checksum -- if
      # `LinuxPlatform.class` changes in a future release, we'll need to
      # recalculate the correct offset.
      echo ${linuxPlatformSHA256} ${class} \
        | sha256sum --check

      # Overwrite the 8 bytes / 4 instructions.
      printf '${repeatString bytesToOverwrite "\\x00"}' \
        | dd of=${class} \
             bs=1 \
             seek=${startOverwritingAt} \
             conv=notrunc

      # Update `LinuxPlatform.class` in the `.jar`.
      zip lib/pde.jar -u ${class}

      # Remove the temporary directory named `processing` and move the shell
      # script named `processing` back to its original location.
      rm -r processing
      mv processing-bin processing
    '');

  installPhase = ''
    mkdir -p $out/${pname}
    rsync --copy-links --safe-links --recursive . $out/${pname}

    # Use our JDK
    rm -r $out/${pname}/java
    ln -s ${jdk} $out/${pname}/java

    for binary in ${pname} ${pname}-java
    do
      makeWrapper $out/${pname}/$binary $out/bin/$binary \
        --argv0 $binary \
        ${
          lib.optionalString (gsettings-desktop-schemas == null)
          "--prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
        } \
        --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=lcd" \
        --prefix LD_LIBRARY_PATH : "${xorg.libXxf86vm}/lib"
    done
  '' + (lib.optionalString (xdg_utils != null) ''
    # See: $out/processing/install.sh
    resource_name="processing-pde"
    desktop_file="$out/${pname}/lib/$resource_name.desktop"
    mkdir -p $out/share/{applications,desktop-directories,icons,mime/packages,icons/hicolor}
    mkdir -p $out/etc/xdg

    substitute "$out/${pname}/lib/desktop.template" "$desktop_file" \
      --replace "<BINARY_LOCATION>" "$out/bin/processing" \
      --replace "<ICON_NAME>" "$resource_name"

    export XDG_UTILS_INSTALL_MODE="system"
    export XDG_DATA_DIRS="$out/share"
    export XDG_CONFIG_DIRS="$out/etc/xdg"

    for size in 16 32 48 64 128 256 512 1024
    do
      for name in "$resource_name" text-x-processing
      do
        xdg-icon-resource install \
          --context mimetypes --size "$size" \
          "$out/${pname}/lib/icons/pde-$size.png" "$resource_name"
      done
    done

    # Install the created *.desktop file
    xdg-desktop-menu install "$desktop_file"

    # Install Processing mime type
    xdg-mime install "$out/${pname}/lib/$resource_name.xml"
  '');

  meta = with stdenv.lib; {
    description = "A language and IDE for electronic arts";
    longDescription = ''
      Processing is a flexible software sketchbook and a language for learning
      how to code within the context of the visual arts. Since 2001, Processing
      has promoted software literacy within the visual arts and visual literacy
      within technology. There are tens of thousands of students, artists,
      designers, researchers, and hobbyists who use Processing for learning and
      prototyping.
    '';
    homepage = "https://processing.org";
    downloadPage = "https://processing.org/download/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
