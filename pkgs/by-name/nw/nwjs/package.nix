{
  alsa-lib,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  buildEnv,
  buildPackages,
  cairo,
  cups,
  dbus,
  expat,
  fetchurl,
  ffmpeg,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libcap,
  libdrm,
  libGL,
  libnotify,
  libuuid,
  libxcb,
  libxkbcommon,
  libgbm,
  nspr,
  nss,
  pango,
  sdk ? false,
  sqlite,
  stdenv,
  systemd,
  udev,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxshmfence,
}:

let
  nwEnv = buildEnv {
    name = "nwjs-env";
    paths = [
      alsa-lib
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libcap
      libdrm
      libGL
      libnotify
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      libx11
      libxscrnsaver
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxtst
      libxshmfence
      # libnw-specific (not chromium dependencies)
      ffmpeg
      libxcb
      # chromium runtime deps (dlopen’d)
      libuuid
      sqlite
      udev
    ];

    extraOutputsToInstall = [
      "lib"
      "out"
    ];
  };

  version = "0.115.0";
in
stdenv.mkDerivation {
  pname = "nwjs";
  inherit version;

  src =
    let
      flavor = if sdk then "sdk-" else "";

      arch =
        if stdenv.hostPlatform.is64bit then
          "x64"
        else if stdenv.hostPlatform.isAarch64 then
          "arm64"
        else
          throw "nwjs: unsupported architecture.";

      # TODO: Write an update script to update all 4 hashes.
      # nixpkgs-update: no auto update
      hashes = {
        "sdk-arm64" = "sha256-yhAQNZ4eMAZIouD+twxfWPgL91b8pRR7YzVODwu0npg=";
        "sdk-x64" = "sha256-H1yRI+xR/7+TDQ6xaswrvqhJcObO9ZVm6qXIDT5FTQc=";
        "arm64" = "sha256-RF2QCVIRKd00heZKyzirCr7ePLjlGza19u8CN4fcxT0=";
        "x64" = "sha256-XlGTxRWd7jwmCXrgSG8q/0tciW21p8f1wr8a4n8rmNk=";
      };
    in
    fetchurl {
      url = "https://dl.nwjs.io/v${version}/nwjs-${flavor}v${version}-linux-${arch}.tar.gz";
      hash = hashes."${flavor + arch}";
    };

  nativeBuildInputs = [
    autoPatchelfHook
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];

  buildInputs = [ nwEnv ];
  appendRunpaths = map (pkg: (lib.getLib pkg) + "/lib") [
    nwEnv
    stdenv.cc.libc
    stdenv.cc.cc
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nwjs
    cp -R * $out/share/nwjs
    find $out/share/nwjs

    ln -s ${lib.getLib systemd}/lib/libudev.so $out/share/nwjs/libudev.so.0

    mkdir -p $out/bin
    ln -s $out/share/nwjs/nw $out/bin

    mkdir $out/lib
    ln -s $out/share/nwjs/lib/libnw.so $out/lib/libnw.so

    runHook postInstall
  '';

  meta = {
    description = "App runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    changelog = "https://github.com/nwjs/nw.js/blob/nw-v${version}/CHANGELOG.md";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      mikaelfangel
      eljamm
    ];
    mainProgram = "nw";
    license = lib.licenses.mit;
  };
}
