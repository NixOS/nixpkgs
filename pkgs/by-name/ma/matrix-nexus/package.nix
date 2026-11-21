# based on upstream's nix packaging, which can be found here:
# https://git.federated.nexus/Nexus/nexus/src/commit/d7006ebeb0aff18f6802bd30c81d87fae3099235/linux/nix/pkg
{
  lib,
  stdenv,
  callPackage,
  fetchFromForgejo,

  mpv-unwrapped,
  gst_all_1,
  ffmpeg-headless,
  libxext,
  libxfixes,
  libclang,
  flutter,
  libunwind,
  orc,
}:

flutter.buildFlutterApplication (finalAttrs: {
  pname = "nexus";
  version = "1.1.3";

  strictDeps = true;

  src = fetchFromForgejo {
    domain = "git.federated.nexus";
    owner = "Nexus";
    repo = "nexus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tSSMuQrUB4ljyWPYxG2z++e0r3DApDvV4P4SZOeu7jE=";
    fetchSubmodules = true;
  };

  preBuild = ''
    cp ${callPackage ./gomuks-ffi.nix { inherit (finalAttrs) src; }}/lib/* .
    packageRunCustom nexus generate source/scripts test
    packageRun build_runner build
  '';

  nativeBuildInputs = [
    # flutter build hooks lose PKG_CONFIG_PATH, so we wrap pkg-config to allow access to native
    # libraries like libxi and libx11. this was fixed upstream, and is temporary until it makes
    # its way to buildFlutterApplication:
    # https://github.com/dart-lang/native/commit/18386375888e370851e2f8851a2d7ca84273d6f5
    (callPackage ./wrap-pkg-config.nix { })
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
    libxext
    libxfixes
    libunwind
    orc
  ];

  env.LIBCLANG_PATH = lib.makeLibraryPath [ libclang ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  # avif_native's build hook downloads its prebuilt library, which the sandbox
  # can't do, so build it from source against nixpkgs' libavif, and point the
  # manifest at it
  customSourceBuilders.avif_native = callPackage ./avif-native.nix { };

  postInstall = ''
    install -D assets/bundled/icon.svg $out/share/icons/hicolor/scalable/apps/nexus.svg
    install -Dm755 linux/*.desktop -t $out/share/applications
    install -Dm644 linux/*.metainfo.xml -t $out/share/metainfo
    install -Dm644 linux/*.service -t $out/share/dbus-1/services
    # better_player loads libmpv at runtime to play videos
    # gomuks uses ffmpeg and ffprobe for video thumbnails and metadata
    wrapProgram $out/bin/nexus \
      --suffix LD_LIBRARY_PATH : $out/app/nexus/lib \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ mpv-unwrapped ]} \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  meta = {
    description = "A simple and user-friendly Matrix client";
    license = lib.licenses.gpl3Only;
    mainProgram = "nexus";
    platforms = lib.platforms.unix;

    # https://github.com/NixOS/nixpkgs/blob/c59305bab2065cfecc4944690d9eedbb56f3a9fa/pkgs/development/compilers/flutter/build-support/build-flutter-application.nix#L15
    broken = stdenv.hostPlatform.isDarwin;

    maintainers = with lib.maintainers; [ logn ];
  };
})
