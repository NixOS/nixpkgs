{
  lib,
  stdenv,
  fetchFromGitHub,
  kdePackages,
  cmake,
  pkg-config,
  wayland-scanner,
  rustc,
  cargo,
  rustPlatform,
  cef-binary,
  mpv-unwrapped,
  mpv,
  systemd,
  libxkbcommon,
  libGL,
  libdrm,
  wayland,
  wayland-protocols,
  libxcb,
  libxcb-cursor,
  libxcb-util,
  ffmpeg,
}:
let
  cef-binary' = cef-binary.override {
    version = "147.0.14";
    gitRevision = "76d2442";
    chromiumVersion = "147.0.7727.138";

    srcHashes = {
      aarch64-linux = "";
      x86_64-linux = "sha256-os7wAFJ+mVK65HCikvEjhMeQUj2ty7y+6Ad0OlOcbeA=";
    };
  };
  mpv-unwrapped' = mpv-unwrapped.overrideAttrs {
    version = "0.41.0-jellyfin-unstable-2026-04-30";
    dontVersionCheck = true;

    src = fetchFromGitHub {
      owner = "andrewrabert";
      repo = "mpv";
      rev = "6242788263ca26352c902d9d336290492a32fa63";
      hash = "sha256-52f4K3cNos1bHpVNbduP1hPckqm76DagbLh0u2YnOqg=";
    };
  };
  mpv' = mpv.override { mpv-unwrapped = mpv-unwrapped'; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jellyfin-desktop";
  version = "0-unstable-2026-05-18";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-desktop";
    rev = "07719a2a2e85ff5e9aa28b9544e68a952c7b6b94";
    hash = "sha256-on8dSiWmHrZoOKvztUV3ZuTu6uw5qasCmghHLxtUkzg=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail /usr/share/plasma-wayland-protocols ${kdePackages.plasma-wayland-protocols}/share/plasma-wayland-protocols
  '';

  cargoRoot = "src";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-ZLphrzZ3+I6CIFa2w/8suXPgeEb6omIkq7RC2XHSx1w=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner

    rustc
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  cmakeFlags = [
    "-DCEF_ROOT=${cef-binary'}"
    "-DEXTERNAL_MPV_DIR=${mpv'}"
  ];

  buildInputs = [
    systemd
    libxkbcommon
    libGL
    libdrm
    wayland
    wayland-protocols
    libxcb
    libxcb-cursor
    libxcb-util
    ffmpeg
  ];

  postInstall = ''
    # replace upstream vendoring with symlinks
    rm $out/libmpv.so

    for i in libEGL.so libGLESv2.so libcef.so libvk_swiftshader.so libvulkan.so.1 v8_context_snapshot.bin; do
      rm -rf $out/$i
      ln -s ${cef-binary'}/Release/$i $out/$i
    done

    for i in chrome_100_percent.pak chrome_200_percent.pak icudtl.dat locales resources.pak; do
      rm -rf $out/$i
      ln -s ${cef-binary'}/Resources/$i $out/$i
    done

    # install desktop file
    install -Dm644 $src/resources/linux/org.jellyfin.JellyfinDesktop.desktop $out/share/applications/org.jellyfin.JellyfinDesktop.desktop
    install -Dm644 $src/resources/linux/org.jellyfin.JellyfinDesktop.svg $out/share/icons/hicolor/scalable/apps/org.jellyfin.JellyfinDesktop.svg

    # link binary into place
    mkdir $out/bin
    ln -s $out/jellyfin-desktop $out/bin/jellyfin-desktop
  '';

  meta = {
    description = "Jellyfin Desktop Client";
    homepage = "https://github.com/jellyfin/jellyfin-desktop";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "jellyfin-desktop";
    platforms = lib.platforms.all;
  };
})
