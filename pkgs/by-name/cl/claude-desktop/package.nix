{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  asar,
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  bash,
  cairo,
  claude-code,
  cups,
  dbus,
  expat,
  gjs,
  glib,
  gtk3,
  kdePackages,
  libcap_ng,
  libGL,
  libayatana-appindicator,
  libgbm,
  libnotify,
  libpulseaudio,
  libseccomp,
  libsecret,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxtst,
  nspr,
  nss,
  OVMF,
  pango,
  pciutils,
  pipewire,
  procps,
  python3,
  qemu_kvm,
  systemd,
  uv,
  virtiofsd,
  vulkan-loader,
  wayland,
  xdg-utils,
  # Needed to import Chrome data on KDE, pulls in Qt
  withKwallet ? false,
  # Cowork sessions uses QEMU/KVM virtual machine
  withCowork ? true,
  # Libraries made available to the prebuilt PyPI packages of Python extensions
  pythonExtensionLibraries ? [ ],
  commandLineArgs ? "",
}:

let
  sources = {
    x86_64-linux = {
      arch = "amd64";
      hash = "sha256-uWIIsgfkULdA99vjBPYHf+2A5/PTfd1UWZHE6CAVZM8=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-/mzYpw+WuW605rZHMAz67mqv9M4TOg+74Rws23dfWmo=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  qemu = "${qemu_kvm}/bin/qemu-system-${stdenv.hostPlatform.qemuArch}";

  # Helpers that app.asar spawns by absolute FHS path
  hostHelpers = {
    "/bin/bash" = lib.getExe bash;
    "/bin/ps" = lib.getExe' procps "ps";
    "/usr/bin/pgrep" = lib.getExe' procps "pgrep";
    "/usr/bin/busctl" = lib.getExe' systemd "busctl";
    "/usr/bin/secret-tool" = lib.getExe' libsecret "secret-tool";
  }
  // lib.optionalAttrs withKwallet {
    "/usr/bin/kwallet-query" = lib.getExe' kdePackages.kwallet "kwallet-query";
  }
  // lib.optionalAttrs withCowork {
    "/usr/bin/qemu-system-x86_64" = qemu;
    "/usr/bin/qemu-system-aarch64" = qemu;
    # The variables template is found by replacing CODE with VARS in the path
    "/usr/share/OVMF/OVMF_CODE_4M.fd" = OVMF.firmware;
    "/usr/share/OVMF/OVMF_CODE.fd" = OVMF.firmware;
    "/usr/share/AAVMF/AAVMF_CODE.fd" = OVMF.firmware;
    "/usr/libexec/virtiofsd" = lib.getExe virtiofsd;
    "/usr/bin/virtiofsd" = lib.getExe virtiofsd;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "claude-desktop";
  version = "5.11492.5";

  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_${source.arch}.deb";
    inherit (source) hash;
  };

  nativeBuildInputs = [
    dpkg
    asar
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libcap_ng
    libgbm
    libseccomp
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    pipewire
    (lib.getLib stdenv.cc.cc)
    systemd
  ];

  runtimeDependencies = map lib.getLib [
    libGL
    libayatana-appindicator
    libnotify
    libpulseaudio
    libsecret
    libuuid
    libxtst
    pciutils
    pipewire
    systemd
    wayland
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;
  # The upstream binaries are already stripped
  dontStrip = true;
  dontWrapGApps = true;

  postPatch = ''
    asar extract usr/lib/claude-desktop/resources/app.asar app

    replaceInApp() {
      local files f
      mapfile -t files < <(grep -rlF --include='*.js' -e "$1" app || true)
      if [[ ''${#files[@]} -eq 0 ]]; then
        echo "error: '$1' not found in app.asar" >&2
        exit 1
      fi
      for f in "''${files[@]}"; do
        substituteInPlace "$f" --replace-fail "$1" "$2"
        # Drop the now stale V8 code cache
        rm -f "app/compile-cache/$(basename "$f")".*.jsc
      done
    }

    ${lib.concatStrings (
      lib.mapAttrsToList (from: to: ''
        replaceInApp '"${from}"' '"${to}"'
      '') hostHelpers
    )}

    # Use claude-code from nixpkgs instead of downloading it, also disables its auto-updater
    replaceInApp 'this.localBinaryPath=null,' 'this.localBinaryPath="${lib.getExe claude-code}",'

    # Use the uv wrapper below instead of one found in PATH or downloaded
    replaceInApp \
      '[UV Discovery] Searching for system UV installation...");' \
      "[UV Discovery] Searching for system UV installation...\");return\"$out/libexec/claude-desktop/uv\";"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -a usr/lib/claude-desktop $out/lib/
    cp -a usr/share $out/
    rm -r $out/share/lintian

    # Repack the patched app, leaving out of the archive the same files as upstream
    resources=$out/lib/claude-desktop/resources
    upstreamUnpacked=usr/lib/claude-desktop/resources/app.asar.unpacked
    rm -r $resources/app.asar $resources/app.asar.unpacked
    unpack=$(find $upstreamUnpacked -type f -printf "$PWD/app/%P\n" | paste -sd,)
    asar pack "$PWD/app" $resources/app.asar --unpack "{$unpack,}"
    diff -r $upstreamUnpacked $resources/app.asar.unpacked
    rm -r $resources/app.asar.unpacked
    cp -a $upstreamUnpacked $resources/

    # Use the nixpkgs Vulkan loader so that the drivers of the host are found
    ln -sf ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 $out/lib/claude-desktop/libvulkan.so.1

    install -Dm644 $resources/linux-mime/com.anthropic.Claude.xml \
      -t $out/share/mime/packages
    install -Dm644 $resources/gnome-search-provider/com.anthropic.Claude.search-provider.ini \
      -t $out/share/gnome-shell/search-providers
    install -Dm644 $resources/gnome-search-provider/com.anthropic.Claude.SearchProvider.service \
      -t $out/share/dbus-1/services
    substituteInPlace $out/share/dbus-1/services/com.anthropic.Claude.SearchProvider.service \
      --replace-fail /usr/bin/gjs ${lib.getExe gjs} \
      --replace-fail /usr/lib/claude-desktop $out/lib/claude-desktop
    substituteInPlace $resources/gnome-search-provider/searchProvider.js \
      --replace-fail 'EXECUTABLE = "claude-desktop"' "EXECUTABLE = \"$out/bin/claude-desktop\""

    substituteInPlace $out/share/applications/com.anthropic.Claude.desktop \
      --replace-fail "Exec=claude-desktop" "Exec=$out/bin/claude-desktop"

    runHook postInstall
  '';

  preFixup = ''
    makeShellWrapper $out/lib/claude-desktop/claude-desktop $out/bin/claude-desktop \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    # The Python that uv downloads by default does not run on NixOS
    makeShellWrapper ${lib.getExe uv} $out/libexec/claude-desktop/uv \
      --set UV_PYTHON_DOWNLOADS never \
      --set UV_PYTHON ${python3.interpreter} \
      ${lib.optionalString (
        pythonExtensionLibraries != [ ]
      ) "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath pythonExtensionLibraries}"}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop application for Claude.ai";
    longDescription = ''
      Desktop application for Claude.ai, with Claude Code and Cowork.

      Python extensions run on the Python interpreter from nixpkgs. Their
      dependencies come from PyPI as prebuilt binaries, and the rare ones that
      need shared libraries can be given them with
      `claude-desktop.override { pythonExtensionLibraries = [ zlib ]; }`.
    '';
    homepage = "https://claude.ai/download";
    downloadPage = "https://downloads.claude.ai/claude-desktop/apt/stable";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ brudel ];
    platforms = lib.attrNames sources;
    mainProgram = "claude-desktop";
  };
})
