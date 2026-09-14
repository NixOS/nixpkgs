{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
  makeDesktopItem,
  writeShellScript,
  nix-update-script,

  dejavu_fonts,
  fontconfig,
  freetype,
  icu,
  krb5,
  libGL,
  libice,
  libsm,
  libx11,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libxtst,
  net-tools,
  openssl,
  xdg-utils,
  zlib,
}:

let
  pname = "apps2samsung";
  version = "2.7.1";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Apps2Samsung/Apps2Samsung/releases/download/v${version}/Apps2Samsung-v${version}-linux-x64.tar.gz";
      hash = "sha256-Qzxx441m2rma5DkP2ehR9iIlxTCOC7VANvkvItW+MCM=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Apps2Samsung/Apps2Samsung/releases/download/v${version}/Apps2Samsung-v${version}-linux-arm64.tar.gz";
      hash = "sha256-yyVPt7jEeqinVjIY3QoKAhwnhNfyEW5lMCoID4xIFkI=";
    };
  };

  meta = {
    description = "Sideload Jellyfin and other apps onto Samsung Tizen TVs, projectors and smart monitors";
    longDescription = ''
      Apps2Samsung (formerly Jellyfin2Samsung) side-loads applications onto Samsung
      devices running Tizen OS. It handles device detection, Samsung developer
      certificate provisioning and installation, so Tizen Studio or manual
      sideloading is not needed. Jellyfin, Moonlight, Moonfin, Litefin, the
      community package catalog and custom `.wgt` files are supported.

      The target device must have Developer Mode enabled.
    '';
    homepage = "https://github.com/Apps2Samsung/Apps2Samsung";
    changelog = "https://github.com/Apps2Samsung/Apps2Samsung/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ confused-engineer ];
    platforms = lib.attrNames sources;
    mainProgram = "apps2samsung";
  };

  apps2samsung-unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-unwrapped";
    inherit version;

    src =
      sources.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    # The release tarball has no top-level directory of its own.
    unpackPhase = ''
      runHook preUnpack

      mkdir -p ${finalAttrs.sourceRoot}
      tar --extract --file=$src --directory=${finalAttrs.sourceRoot}

      runHook postUnpack
    '';
    sourceRoot = "source";

    strictDeps = true;

    dontConfigure = true;
    dontBuild = true;

    # A self-contained .NET single-file publish that is only ever run inside the
    # FHS environment below, so it must keep its /lib64 interpreter.
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/${pname}
      cp -r . $out/share/${pname}

      rm $out/share/${pname}/*.pdb

      # esbuild ships without the executable bit. The application chmods it on
      # first use, which cannot work from the read-only store.
      chmod +x $out/share/${pname}/Assets/esbuild/linux-*/esbuild

      # Mount points for the writable state bind-mounted in by the wrapper.
      # bubblewrap cannot create them inside a read-only bind mount.
      mkdir -p $out/share/${pname}/Logs $out/share/${pname}/Downloads
      touch $out/share/${pname}/third-party-apps.cache.json

      runHook postInstall
    '';

    meta = builtins.removeAttrs meta [ "mainProgram" ];
  });

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Apps2Samsung";
    comment = "Install any app on Samsung TVs, projectors and smart monitors";
    exec = pname;
    icon = pname;
    terminal = false;
    type = "Application";
    categories = [
      "Utility"
      "Network"
    ];
    keywords = [
      "jellyfin"
      "samsung"
      "sideload"
      "tizen"
      "tv"
    ];
    startupNotify = true;
    startupWMClass = "Apps2Samsung";
  };
in
buildFHSEnv {
  inherit pname version meta;

  targetPkgs = _: [
    # .NET runtime: libstdc++/libgcc_s, globalization, TLS and GSSAPI, all of
    # which the single-file bundle dlopens after unpacking itself
    stdenv.cc.cc.lib
    icu
    krb5
    openssl
    zlib

    # Skia / font rendering
    dejavu_fonts
    fontconfig
    freetype
    libGL

    # Avalonia X11 backend
    libice
    libsm
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxinerama
    libxrandr
    libxrender
    libxtst

    # `arp`, used to resolve the MAC vendor of discovered devices
    net-tools
    # `xdg-open`, used by the "open logs folder" and release-page buttons
    xdg-utils
  ];

  # The application keeps logs, downloaded packages and the Tizen SDB binary it
  # fetches at runtime next to its own executable, so those paths get a writable
  # bind mount. Everything else it writes (settings, generated signing
  # certificates) already goes to $XDG_CONFIG_HOME/Apps2Samsung.
  #
  # Installing under /opt additionally makes the application report itself as
  # package-manager managed and skip its built-in auto-updater, which would
  # otherwise try to replace the store path.
  extraPreBwrapCmds = ''
    state="''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}"
    mkdir -p "$state"/Logs "$state"/Downloads "$state"/TizenSDB
    [ -e "$state/third-party-apps.cache.json" ] || : > "$state/third-party-apps.cache.json"
  '';

  extraBwrapArgs = [
    "--tmpfs /opt"
    "--ro-bind ${apps2samsung-unwrapped}/share/${pname} /opt/apps2samsung"
    ''--bind "$state/Logs" /opt/apps2samsung/Logs''
    ''--bind "$state/Downloads" /opt/apps2samsung/Downloads''
    ''--bind "$state/TizenSDB" /opt/apps2samsung/Assets/TizenSDB''
    ''--bind "$state/third-party-apps.cache.json" /opt/apps2samsung/third-party-apps.cache.json''
  ];

  runScript = writeShellScript "${pname}-run" ''
    exec /opt/apps2samsung/Apps2Samsung "$@"
  '';

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/${pname}.desktop -t $out/share/applications
    install -Dm444 ${apps2samsung-unwrapped}/share/${pname}/Assets/jelly2sams.png \
      $out/share/icons/hicolor/256x256/apps/${pname}.png
  '';

  passthru = {
    unwrapped = apps2samsung-unwrapped;
    updateScript = nix-update-script { };
  };
}
