{
  lib,
  stdenv,
  fetchurl,

  # build-time
  autoPatchelfHook,
  buildPackages,

  # run-time
  alsa-lib,
  at-spi2-core,
  atk,
  buildEnv,
  cairo,
  cups,
  dbus,
  expat,
  ffmpeg,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libcap,
  libdrm,
  libgbm,
  libnotify,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  nspr,
  nss,
  pango,
  sqlite,
  systemd,
  udev,

  # update script
  writeShellApplication,
  common-updater-scripts,
  curl,
  jq,

  # options
  sdk ? false,
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
      libGL
      libcap
      libdrm
      libgbm
      libnotify
      libx11
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxkbcommon
      libxrandr
      libxrender
      libxscrnsaver
      libxshmfence
      libxtst
      nspr
      nss
      pango
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
in

stdenv.mkDerivation (finalAttrs: {
  pname = "nwjs";
  version = "0.117.0";

  src =
    let
      flavor = if sdk then "sdk" else "normal";

      arch =
        if stdenv.hostPlatform.is64bit then
          "x64"
        else if stdenv.hostPlatform.isAarch64 then
          "arm64"
        else
          throw "nwjs: unsupported architecture.";
    in
    finalAttrs.passthru.srcs."${flavor}-${arch}";

  nativeBuildInputs = [
    autoPatchelfHook
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];

  buildInputs = [
    nwEnv
  ];

  appendRunpaths = map (pkg: (lib.getLib pkg) + "/lib") [
    nwEnv
    stdenv.cc.cc
    stdenv.cc.libc
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

  passthru = {
    srcs =
      let
        mkUrl =
          flavor: arch:
          "https://dl.nwjs.io/v${finalAttrs.version}/nwjs-${
            lib.optionalString (flavor == "sdk") "sdk-"
          }v${finalAttrs.version}-linux-${arch}.tar.gz";
      in
      {
        normal-arm64 = fetchurl {
          url = mkUrl "normal" "arm64";
          hash = "sha256-fYzBiRradqodDhIeI3rXYnGC/W/VrpKsLiuvtwiWL5w=";
        };
        normal-x64 = fetchurl {
          url = mkUrl "normal" "x64";
          hash = "sha256-KIHtHzqQMdWNj6DwcU0L2se0XVK97Alc1yqk8x4I3r8=";
        };
        sdk-arm64 = fetchurl {
          url = mkUrl "sdk" "arm64";
          hash = "sha256-2BHtclshr1mEovMTbyW0g0BNPgpsO2PcGSlpHxncvKQ=";
        };
        sdk-x64 = fetchurl {
          url = mkUrl "sdk" "x64";
          hash = "sha256-ZkQ7WgnrtDpW8xHpX8F4wBhTUG17cgM2BeqmsaFwTuw=";
        };
      };

    updateScript = lib.getExe (writeShellApplication {
      name = "update-nwjs";
      runtimeInputs = [
        common-updater-scripts
        curl
        jq
      ];
      text = ''
        LATEST_VERSION="$(curl -sL https://nwjs.io/versions.json | jq -r '.stable' | sed 's/^v//')"
        ARCHIVE_NAMES="${toString (lib.attrNames finalAttrs.passthru.srcs)}"

        for name in $ARCHIVE_NAMES; do
          update-source-version nwjs "$LATEST_VERSION" \
            --source-key="passthru.srcs.$name" \
            --ignore-same-version \
            --print-changes
        done
      '';
    });
  };

  meta = {
    description = "App runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    changelog = "https://github.com/nwjs/nw.js/blob/nw-v${finalAttrs.version}/CHANGELOG.md";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      mikaelfangel
      eljamm
    ];
    mainProgram = "nw";
    license = lib.licenses.mit;
  };
})
