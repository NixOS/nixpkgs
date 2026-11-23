{
  stdenv,
  lib,
  makeBinaryWrapper,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  zulu25,
  dpkg,
  writeShellScript,
  zip,
  unzip,
  gnupg,
  coreutils,
  gnugrep,
  gnused,
  patchelf,

  # Used by the bundled webcam-app
  libv4l,

  # Used by the testing package bisq2-webcam-app
  callPackage,
  socat,

  # Dependencies for bundled Tor
  glibc,
  libz,
}:

let
  version = "2.1.16";

  jdk = zulu25.override { enableJavaFX = true; };

  argumentFile = builtins.toFile "app.args" ''
    -Djpackage.app-version=${version}
    -classpath
    @out@/lib/app/desktop-app-launcher.jar:@classpath@
  '';

  bisq-launcher =
    args:
    writeShellScript "bisq-launcher" ''
      # This is just a comment to convince Nix that this package
      # needs Tor's dependencies to execute the bundled Tor binary.
      # ${glibc} ${libz}

      rm -fR $HOME/.local/share/Bisq2/tor

      exec "${lib.getExe jdk}" @@out@/lib/app.args ${args} bisq.desktop_app_launcher.DesktopAppLauncher "$@"
    '';

  # A given release will be signed by either Alejandro Garcia or Henrik Jannsen
  # as indicated in the file
  # https://github.com/bisq-network/bisq2/releases/download/v${version}/signingkey.asc
  publicKey = {
    "E222AA02" = fetchurl {
      url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/E222AA02.asc";
      hash = "sha256-a+fUJT8nXqhOIULiXxdqVoTymE4qBIHiU7i0YJpI1RU=";
    };

    "387C8307" = fetchurl {
      url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/387C8307.asc";
      hash = "sha256-9tdyU9ezFRINlInvvAj6JrUQB8i4LIs9q7ZWQhDaenU=";
    };
  };

  binPath = lib.makeBinPath [
    coreutils
  ];

  libraryPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libv4l
  ];
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;

  pname = "bisq2";

  # nixpkgs-update: no auto update
  src = fetchurl {
    url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb";
    hash = "sha256-SU7eUSesH7AZ2Znt4r8hZpcQJiVhx2vx+RH1tj1faPY=";

    # Verify the upstream Debian package prior to extraction.
    # See https://bisq.wiki/Bisq_2#Installation
    # This ensures that a successful build of this Nix package requires the Debian
    # package to pass verification.
    nativeBuildInputs = [ gnupg ];
    downloadToTemp = true;

    postFetch = ''
      pushd $(mktemp -d)
      export GNUPGHOME=./gnupg
      mkdir -m 700 -p $GNUPGHOME
      ln -s $downloadedFile ./Bisq-${version}.deb
      ln -s ${finalAttrs.signature} ./signature.asc
      gpg --import ${publicKey."E222AA02"}
      gpg --import ${publicKey."387C8307"}
      gpg --batch --verify signature.asc Bisq-${version}.deb
      popd
      mv $downloadedFile $out
    '';
  };

  signature = fetchurl {
    url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb.asc";
    hash = "sha256-Ht4wO+oZt8mnGfN+S+kVGvo5IoFELBo0t/ERsTwhJsU=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    imagemagick
    makeBinaryWrapper
    zip
    unzip
    gnupg
    gnugrep
    gnused
    patchelf
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "bisq2";
      exec = "bisq2";
      icon = "bisq2";
      desktopName = "Bisq 2";
      genericName = "Decentralized bitcoin exchange";
      categories = [
        "Network"
        "P2P"
      ];
    })

    (makeDesktopItem {
      name = "bisq2-hidpi";
      exec = "bisq2-hidpi";
      icon = "bisq2";
      desktopName = "Bisq 2 (HiDPI)";
      genericName = "Decentralized bitcoin exchange";
      categories = [
        "Network"
        "P2P"
      ];
    })
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  buildPhase =
    let
      torJarName = "tor-1.0.1";
    in
    ''
      # Prepare the bundled Tor binary to run on NixOS
      # within the Bisq Tor sandbox, "sandy".
      # See https://github.com/bisq-network/sandy

      mkdir ${torJarName}
      mkdir tor-zip

      # Unpack the .jar containing Tor.
      pushd ${torJarName}
      unzip ../opt/bisq2/lib/app/${torJarName}.jar
      popd

      # Unpack the .zip containing the Tor binary.
      pushd tor-zip
      unzip ../${torJarName}/tor.zip

      # Copy all dependencies the OS is supposed to provide,
      # except ld, because they won't be accessible
      # from within the sandbox at their /nix/store locations
      interpreter="$(< "$NIX_CC/nix-support/dynamic-linker")"
      patchelf --set-interpreter "$interpreter" tor

      cp -L ${glibc}/lib/libc.so.6 ./
      cp -L ${glibc}/lib/libdl.so.2 ./
      cp -L ${glibc}/lib/libpthread.so.0 ./
      cp -L ${glibc}/lib/libm.so.6 ./
      cp -L ${libz}/lib/libz.so.1 ./

      # Repack the .zip
      zip -r ../${torJarName}/tor.zip .
      popd

      # Repack the .jar
      pushd ${torJarName}
      zip -r ../opt/bisq2/lib/app/${torJarName}.jar .
      popd
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r opt/bisq2/lib/app $out/lib

    export classpath=$(ls -1 $out/lib/app/ | grep -v desktop-app-launcher.jar | sort | sed -e 's/^/@out@\/lib\/app\//g' | tr '\n' ':')
    cp -L ${argumentFile} $out/lib/app.args
    substituteAllInPlace $out/lib/app.args

    install -D -m 777 ${bisq-launcher ""} $out/bin/bisq2
    substituteAllInPlace $out/bin/bisq2
    wrapProgram $out/bin/bisq2 --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    install -D -m 777 ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq2-hidpi
    substituteAllInPlace $out/bin/bisq2-hidpi
    wrapProgram $out/bin/bisq2-hidpi --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      magick convert opt/bisq2/lib/Bisq2.png -resize $size bisq2.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq2.png
    done;

    runHook postInstall
  '';

  # The bisq2.webcam-app package is for maintainers to test scanning QR codes.
  passthru.webcam-app = callPackage ./webcam-app.nix {
    inherit
      jdk
      libraryPath
      ;
    bisq2 = finalAttrs.finalPackage.out;
  };

  meta = {
    description = "Decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    mainProgram = "bisq2";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emmanuelrosa ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
