{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  fetchFromGitHub,
  dpkg,
  glib,
  gnutar,
  gtk3-x11,
  luajit,
  sdcv,
  SDL2,
  openssl,
  nix-update-script,
}:
let
  luajit_lua52 = luajit.override { enable52Compat = true; };
in
stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2025.04";

  src =
    {
      aarch64-linux = fetchurl {
        url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-arm64.deb";
        hash = "sha256-bpKNP+1C0oHZEv6HGL4dBziv3RfCow882yV8JFLtDJ4=";
      };
      armv7l-linux = fetchurl {
        url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-armhf.deb";
        hash = "sha256-q3M33f0b5FAU/nmPfzsXu93mVZOhXMVgBbfwnieqkeM=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
        hash = "sha256-ZZujk98YVvNJmffW2fDg+n+z1xgtkha7y1LasYEhCR4=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src_repo = fetchFromGitHub {
    repo = "koreader";
    owner = "koreader";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Kt00AZARfQjGY8FzDcQB8UaowWW2+KWyXJzexFNmZmM=";
  };

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];
  buildInputs = [
    glib
    gnutar
    gtk3-x11
    luajit_lua52
    sdcv
    SDL2
    openssl
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x $src .
    cp -R usr/* $out/

    # Link required binaries
    ln -sf ${luajit_lua52}/bin/luajit $out/lib/koreader/luajit
    ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
    ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar

    # Link SSL/network libraries
    ln -sf ${openssl.out}/lib/libcrypto.so.3 $out/lib/koreader/libs/libcrypto.so.1.1
    ln -sf ${openssl.out}/lib/libssl.so.3 $out/lib/koreader/libs/libssl.so.1.1

    # Copy fonts
    find ${src_repo}/resources/fonts -type d -execdir cp -r '{}' $out/lib/koreader/fonts \;

    # Remove broken symlinks
    find $out -xtype l -print -delete

    wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : $out/lib/koreader/libs:${
      lib.makeLibraryPath [
        gtk3-x11
        SDL2
        glib
        stdenv.cc.cc
        openssl.out
      ]
    }
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/koreader/koreader";
    changelog = "https://github.com/koreader/koreader/releases/tag/v${version}";
    description = "Ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    mainProgram = "koreader";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      contrun
      neonfuz
      liberodark
    ];
  };
}
