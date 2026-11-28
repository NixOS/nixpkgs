{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  dpkg,
  asar,
  autoPatchelfHook,
  makeBinaryWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libcap_ng,
  libdrm,
  libgbm,
  libglvnd,
  libnotify,
  libpulseaudio,
  libseccomp,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxkbcommon,
  nspr,
  nss,
  pango,
  pipewire,
  systemdLibs,
  OVMF,
  xdg-utils,
  git,
  openssh,
  procps,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  commandLineArgs ? [ ],
}:

let
  pname = "claude-desktop";
  version = "4.4212.0";

  fwPrefix = if stdenvNoCC.hostPlatform.isAarch64 then "AAVMF" else "OVMF";
  ovmfCode = "${OVMF.fd}/FV/${fwPrefix}_CODE.fd";
  ovmfVars = "${OVMF.fd}/FV/${fwPrefix}_VARS.fd";

  meta = {
    description = "Desktop application for Claude.ai";
    homepage = "https://claude.ai/download";
    license = lib.licenses.unfree;
    mainProgram = "claude-desktop";
    maintainers = with lib.maintainers; [
      minegameYTB
      kleinbem
      ooonea
      diwangs
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  unwrapped = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname version meta;

    src =
      if stdenvNoCC.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_amd64.deb";
          hash = "sha256-T89ljg/IlTkKuCWTKHKB37ziYbDsPqkAYOgti/v9eoQ=";
        }
      else if stdenvNoCC.hostPlatform.system == "aarch64-linux" then
        fetchurl {
          url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_arm64.deb";
          hash = "sha256-cCLcVt4w4L63+gp9yE4JqgDX+dTht/kwQ7Mrr3Wi9tg=";
        }
      else
        throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

    nativeBuildInputs = [
      dpkg
      asar
      autoPatchelfHook
      makeBinaryWrapper
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
      libdrm
      libgbm
      libseccomp
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxkbcommon
      nspr
      nss
      pango
      pipewire
      systemdLibs
      libsecret
    ];

    appendRunpaths = [
      "${libglvnd}/lib"
      "${libnotify}/lib"
      "${libpulseaudio}/lib"
      "${libsecret}/lib"
      "${pipewire}/lib"
    ];

    strictDeps = true;
    __structuredAttrs = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb --fsys-tarfile "$src" | tar -x --no-same-owner --no-same-permissions
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r usr/lib usr/share "$out/"
      rm -rf "$out/share/lintian"

      # Drop SUID sandbox helper: NixOS uses unprivileged user namespaces instead.
      rm -f "$out/lib/claude-desktop/chrome-sandbox"

      # Patch Google OAuth deep-link callback handling in app.asar to prevent silent eviction on Linux second-instance handoff
      asar extract "$out/lib/claude-desktop/resources/app.asar" asar-unpacked
      mainChunk=$(grep -l "desktop_login_callback_evicted" asar-unpacked/.vite/build/index.chunk-*.js)
      substituteInPlace "$mainChunk" \
        --replace-fail "!(r!=null&&!i&&gfr(r.getURL()))" "!(r!=null&&gfr(r.getURL()))" \
        --replace-fail 'var hfr=new Set(["/login","/gift/redeem"]);' 'var hfr=new Set(["/login","/gift/redeem","/",""]);' \
        --replace-fail 'function EU(e){let t=e.webContents;return!t||t.isDestroyed()||!ufr.has(t)}' 'function EU(e){let t=e.webContents;return!t||t.isDestroyed()}'
      rm -rf asar-unpacked/compile-cache
      asar pack asar-unpacked "$out/lib/claude-desktop/resources/app.asar"
      rm -rf asar-unpacked

      # Point .desktop Exec at wrapper
      desktopFile=$(echo "$out/share/applications/"*.desktop)
      substituteInPlace "$desktopFile" \
        --replace-fail "Exec=claude-desktop" "Exec=$out/bin/claude-desktop"

      mkdir -p "$out/bin"
      makeWrapper "$out/lib/claude-desktop/claude-desktop" "$out/bin/claude-desktop" \
        --prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share:${gsettings-desktop-schemas}/share:$out/share" \
        --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
        --add-flags "--ozone-platform-hint=auto" \
        --add-flags "--enable-features=GlobalShortcutsPortal,WaylandWindowDecorations" \
        --add-flags "--enable-wayland-ime" \
        --add-flags "--wayland-text-input-version=3" \
        --add-flags "\''${CLAUDE_USE_X11:+--ozone-platform=x11}" \
        --set-default GTK_USE_PORTAL "1" \
        --set CHROME_DESKTOP "com.anthropic.Claude.desktop" \
        ${lib.optionalString (
          commandLineArgs != [ ]
        ) "--add-flags ${lib.escapeShellArg (lib.escapeShellArgs commandLineArgs)}"}

      runHook postInstall
    '';
  });
in
let
  fhsEnv = buildFHSEnv {
    inherit pname version;

    targetPkgs = pkgs: [
      unwrapped

      # Graphics and dynamic loader for Chromium / GPU acceleration
      pkgs.glibc
      pkgs.libglvnd
      pkgs.mesa
      pkgs.vulkan-loader

      # Virtualization tooling for Cowork VMs
      pkgs.qemu_kvm

      # Runtime CLI utilities invoked by Claude Code, MCP servers, and Cowork
      pkgs.python3
      pkgs.nodejs
      pkgs.git
      pkgs.openssh
      pkgs.procps
      pkgs.xdg-utils
    ];

    extraBuildCommands = ''
      # Firmware paths probed by Cowork VM
      mkdir -p "$out/usr/share/${fwPrefix}"
      ln -s ${ovmfCode} "$out/usr/share/${fwPrefix}/${fwPrefix}_CODE.fd"
      ln -s ${ovmfCode} "$out/usr/share/${fwPrefix}/${fwPrefix}_CODE_4M.fd"
      ln -s ${ovmfVars} "$out/usr/share/${fwPrefix}/${fwPrefix}_VARS.fd"
      ln -s ${ovmfVars} "$out/usr/share/${fwPrefix}/${fwPrefix}_VARS_4M.fd"

      # Use Anthropic's bundled virtiofsd (patchelfed above with libseccomp/libcap_ng) for Cowork VM fallback
      mkdir -p "$out/usr/libexec"
      ln -sf "${unwrapped}/lib/claude-desktop/resources/virtiofsd" "$out/usr/libexec/virtiofsd"

      # Absolute-path helpers
      mkdir -p "$out/usr/bin"
      ln -sf ${lib.getExe git} "$out/usr/bin/git"
      ln -sf ${openssh}/bin/ssh "$out/usr/bin/ssh"
      ln -sf ${procps}/bin/pgrep "$out/usr/bin/pgrep"
    '';

    extraInstallCommands = ''
      mkdir -p "$out/share"
      cp -r ${unwrapped}/share/* "$out/share/"
      chmod -R u+w "$out/share"
      substituteInPlace "$out/share/applications/"*.desktop \
        --replace-fail "${unwrapped}/bin/claude-desktop" "$out/bin/claude-desktop"
    '';

    runScript = "${unwrapped}/bin/claude-desktop";
    dieWithParent = true;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version meta;
  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin" "$out/share"
    ln -s "${fhsEnv}/bin/${pname}" "$out/bin/${pname}"
    ln -s ${fhsEnv}/share/* "$out/share/"
  '';

  passthru = {
    inherit unwrapped fhsEnv;
    updateScript = ./update.sh;
  };
}
