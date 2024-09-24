{ lib, autoPatchelfHook, bzip2, cairo, fetchurl, gdk-pixbuf, glibc, pango, gtk2, kcoreaddons, ki18n, kio, kservice
, stdenv, runtimeShell, unzip
}:

let
  pname = "bcompare";
  version = "4.4.6.27483";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://www.scootersoftware.com/${pname}-${version}_amd64.deb";
      sha256 = "sha256-1+f/AfyJ8Z80WR4cs1JDjTquTR1mGAUOd27vniSeA0k=";
    };

    x86_64-darwin = fetchurl {
      url = "https://www.scootersoftware.com/BCompareOSX-${version}.zip";
      sha256 = "sha256-hUzJfUgfCuvB6ADHbsgmEXXgntm01hPnfSjwl7jI70c=";
    };

    aarch64-darwin = srcs.x86_64-darwin;
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  linux = stdenv.mkDerivation {
    inherit pname version src meta;
    unpackPhase = ''
      ar x $src
      tar xfz data.tar.gz
    '';

    installPhase = ''
      mkdir -p $out/{bin,lib,share}

      cp -R usr/{bin,lib,share} $out/

      # Remove library that refuses to be autoPatchelf'ed
      rm $out/lib/beyondcompare/ext/bcompare_ext_kde.amd64.so

      substituteInPlace $out/bin/${pname} \
        --replace "/usr/lib/beyondcompare" "$out/lib/beyondcompare" \
        --replace "ldd" "${glibc.bin}/bin/ldd" \
        --replace "/bin/bash" "${runtimeShell}"

      # Create symlink bzip2 library
      ln -s ${bzip2.out}/lib/libbz2.so.1 $out/lib/beyondcompare/libbz2.so.1.0
    '';

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      stdenv.cc.cc.lib
      gtk2
      pango
      cairo
      kio
      kservice
      ki18n
      kcoreaddons
      gdk-pixbuf
      bzip2
    ];

    dontBuild = true;
    dontConfigure = true;
    dontWrapQtApps = true;
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;
    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/Applications/BCompare.app
      cp -R . $out/Applications/BCompare.app
    '';
  };

  meta = with lib; {
    description = "GUI application that allows to quickly and easily compare files and folders";
    longDescription = ''
      Beyond Compare is focused. Beyond Compare allows you to quickly and easily compare your files and folders.
      By using simple, powerful commands you can focus on the differences you're interested in and ignore those you're not.
      You can then merge the changes, synchronize your files, and generate reports for your records.
    '';
    homepage = "https://www.scootersoftware.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ktor arkivm ];
    platforms = builtins.attrNames srcs;
    mainProgram = "bcompare";
  };
in
if stdenv.hostPlatform.isDarwin
then darwin
else linux
