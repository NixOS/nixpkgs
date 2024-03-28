{ copyDesktopItems
, dbus
, fetchurl
, fontconfig
, freetype
, glib
, lib
, libGL
, libkrb5
, libsecret
, libunwind
, libxkbcommon
, makeDesktopItem
, makeWrapper
, openssl
, stdenv
, xorg
, zlib
}:

let
  srcs = builtins.fromJSON (builtins.readFile ./srcs.json);
in
stdenv.mkDerivation rec {
  pname = "ida-free";
  version = "v8.4.240320sp1";

  src = fetchurl {
    inherit (srcs.${stdenv.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")) url sha256;
  };

  icon = fetchurl {
    urls = [
      "https://www.hex-rays.com/products/ida/news/8_1/images/icon_free.png"
      "https://web.archive.org/web/20221105181231if_/https://hex-rays.com/products/ida/news/8_1/images/icon_free.png"
    ];
    sha256 = "sha256-widkv2VGh+eOauUK/6Sz/e2auCNFAsc8n9z0fdrSnW0=";
  };

  desktopItem = makeDesktopItem {
    name = "ida-free";
    exec = "ida64";
    icon = icon;
    comment = meta.description;
    desktopName = "IDA Free";
    genericName = "Interactive Disassembler";
    categories = [ "Development" ];
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  # We just get a runfile in $src, so no need to unpack it.
  dontUnpack = true;

  installPhase =
    let
      libraries = [
        dbus
        fontconfig
        freetype
        glib
        libGL
        libkrb5
        libsecret
        libunwind
        libxkbcommon
        openssl
        stdenv.cc.cc
        xorg.libICE
        xorg.libSM
        xorg.libX11
        xorg.libXau
        xorg.libxcb
        xorg.libXext
        xorg.libXi
        xorg.libXrender
        xorg.xcbutilimage
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        xorg.xcbutilwm
        zlib
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/bin $out/lib $out/opt/ida-free

      # IDA depends on quite some things extracted by the runfile, so first extract everything
      # into $out/opt/ida-free, then remove the unnecessary files and directories.
      IDADIR=$out/opt/ida-free

      # Invoke the installer with the dynamic loader directly, avoiding the need
      # to copy it to fix permissions and patch the executable.
      $(cat $NIX_CC/nix-support/dynamic-linker) $src \
        --mode unattended --prefix $IDADIR --installpassword ""

      # Copy the exported libraries to the output.
      cp $IDADIR/libida64.so $out/lib

      for bb in ida64 assistant; do
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          $IDADIR/$bb

        wrapProgram \
          $IDADIR/$bb \
          --set QT_PLUGIN_PATH "$IDADIR/plugins/platforms" \
          --set LD_LIBRARY_PATH "$IDADIR:${lib.makeLibraryPath libraries}"

        ln -s $IDADIR/$bb $out/bin/$bb
      done

      ls -la $IDADIR

      runHook postInstall
    '';

  meta = with lib; {
    description = "Freeware version of the world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-free/";
    license = licenses.unfree;
    mainProgram = "ida64";
    maintainers = with maintainers; [ msanft ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
