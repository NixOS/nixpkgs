{
  stdenvNoCC,
  stdenv,
  lib,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  buildFHSEnv,

  # temurin JDK dependencies
  alsa-lib,
  fontconfig,
  freetype,
  libffi,
  xorg,
  zlib,
  cups,
  cairo,
  glib,
  gtk3,
  libGL,

  # tor dependencies
  libevent,
  openssl,
  xz,
  zstd,
  scrypt,
  libseccomp,
  systemd,
  libcap,

  imagemagick,
  gnupg,
  libusb1,
  pcsclite,
  udevCheckHook,
}:

let
  sparrowArch =
    {
      x86_64-linux = "x86_64";
      aarch64-linux = "aarch64";
    }
    ."${stdenvNoCC.hostPlatform.system}";

  sparrow-unwrapped = stdenvNoCC.mkDerivation rec {
    version = "2.3.0";
    pname = "sparrow-unwrapped";
    nativeBuildInputs = [
      copyDesktopItems
      udevCheckHook
      imagemagick
      gnupg
    ];

    # nixpkgs-update: no auto update
    src = fetchurl {
      url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrowwallet-${version}-${sparrowArch}.tar.gz";
      hash =
        {
          x86_64-linux = "sha256-PmZpxyTXzQMIAGH0edxEHCwzb+k8HBJYXnfyZkpCnoM=";
          aarch64-linux = "sha256-H4S07T/oskEe8QcBieUogaZGVRJ+CihaH569e5QUScc=";
        }
        ."${stdenvNoCC.hostPlatform.system}";
    };

    # preUnpack is used to verify the signed upstream package.
    # The signature is not a self-contained file.
    # Instead the SHA256 of the package is added to a manifest file.
    # The manifest file is signed by the owner of the public key, Craig Raw.
    # Thus to verify the signed package, the manifest is verified with the public key,
    # and then the package is verified against the manifest.
    # The public key is obtained from https://keybase.io/craigraw/pgp_keys.asc
    # and is included in this repo to provide reproducibility.
    preUnpack =
      let
        manifest = fetchurl {
          url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrow-${version}-manifest.txt";
          hash = "sha256-QNlbu9Y7kJ0fvqHubyP8/yAIEiw6mWzVnsyJTXJcWqk=";
        };

        manifestSignature = fetchurl {
          url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrow-${version}-manifest.txt.asc";
          hash = "sha256-H3PDTGypdqhCtCXTecwLUNrlhGvxESDaKb4O2LOXXbA=";
        };

        publicKey = ./publickey.asc;
      in
      ''
        pushd $(mktemp -d)
        export GNUPGHOME=$PWD/gnupg
        mkdir -m 700 -p $GNUPGHOME
        ln -s ${manifest} ./manifest.txt
        ln -s ${manifestSignature} ./manifest.txt.asc
        ln -s $src ./sparrowwallet-${version}-${sparrowArch}.tar.gz
        gpg --import ${publicKey}
        gpg --verify manifest.txt.asc manifest.txt
        sha256sum -c --ignore-missing manifest.txt
        popd
      '';

    desktopItems = [
      (makeDesktopItem {
        name = "sparrow";
        exec = "sparrow";
        icon = "sparrow";
        desktopName = "Sparrow Bitcoin Wallet";
        genericName = "Bitcoin Wallet";
        categories = [
          "Finance"
          "Network"
        ];
        mimeTypes = [
          "application/psbt"
          "application/bitcoin-transaction"
          "x-scheme-handler/bitcoin"
          "x-scheme-handler/auth47"
          "x-scheme-handler/lightning"
        ];
        startupWMClass = "Sparrow";
      })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/etc/udev
      mkdir -p $out/share/icons/hicolor
      cp bin/Sparrow $out/bin/
      cp -r lib/ $out/
      rm $out/lib/runtime/conf/udev/README.md

      for n in 16 24 32 48 64 96 128 256; do
        size=$n"x"$n
        mkdir -p $out/share/icons/hicolor/$size/apps
        convert lib/Sparrow.png -resize $size $out/share/icons/hicolor/$size/apps/sparrow.png
      done;

      mkdir -p $out/etc/udev/
      ln -s $out/lib/runtime/conf/udev $out/etc/udev/rules.d

      runHook postInstall
    '';

    doInstallCheck = true;
  };
in
buildFHSEnv {
  pname = "sparrow";
  version = sparrow-unwrapped.version;
  runScript = "${sparrow-unwrapped}/bin/Sparrow";

  targetPkgs = pkgs: [
    (lib.getLib stdenv.cc.cc) # libstdc++.so.6
    alsa-lib
    fontconfig
    freetype
    libffi
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
    zlib
    cups
    cairo
    glib
    gtk3
    libGL
    libevent
    openssl
    xz
    zstd
    scrypt
    libseccomp
    systemd
    libcap
    libusb1
    pcsclite
  ];

  extraInstallCommands = ''
    ln -sf ${sparrow-unwrapped}/share $out
    ln -sf ${sparrow-unwrapped}/etc $out
  '';

  meta = with lib; {
    description = "Modern desktop Bitcoin wallet application supporting most hardware wallets and built on common standards such as PSBT, with an emphasis on transparency and usability";
    homepage = "https://sparrowwallet.com";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [
      emmanuelrosa
      msgilligan
      _1000101
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "sparrow";
  };
}
