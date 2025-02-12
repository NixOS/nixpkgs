{
  lib,
  stdenv,
  fetchurl,
  config,
  wrapGAppsHook3,
  autoPatchelfHook,
  alsa-lib,
  curl,
  dbus-glib,
  gtk3,
  libXtst,
  libva,
  pciutils,
  pipewire,
  adwaita-icon-theme,
  channel,
  generated,
  writeScript,
  writeText,
  xidel,
  coreutils,
  gnused,
  gnugrep,
  gnupg,
  runtimeShell,
  systemLocale ? config.i18n.defaultLocale or "en_US",
  patchelfUnstable, # have to use patchelfUnstable to support --no-clobber-old-sections
}:

let

  inherit (generated) version sources;

  binaryName = if channel == "release" then "firefox" else "firefox-${channel}";

  mozillaPlatforms = {
    i686-linux = "linux-i686";
    x86_64-linux = "linux-x86_64";
  };

  arch = mozillaPlatforms.${stdenv.hostPlatform.system};

  isPrefixOf = prefix: string: builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source: (isPrefixOf source.locale locale) && source.arch == arch;

  policies = {
    DisableAppUpdate = true;
  } // config.firefox.policies or { };

  policiesJson = writeText "firefox-policies.json" (builtins.toJSON { inherit policies; });

  defaultSource = lib.findFirst (sourceMatches "en-US") { } sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia" then
      "ca-valencia"
    else
      lib.replaceStrings [ "_" ] [ "-" ] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  pname = "firefox-${channel}-bin-unwrapped";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl { inherit (source) url sha256; };

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
    patchelfUnstable
  ];
  buildInputs = [
    gtk3
    adwaita-icon-theme
    alsa-lib
    dbus-glib
    libXtst
  ];
  runtimeDependencies = [
    curl
    libva.out
    pciutils
  ];
  appendRunpaths = [
    "${pipewire}/lib"
  ];
  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  installPhase = ''
    mkdir -p "$prefix/lib/firefox-bin-${version}"
    cp -r * "$prefix/lib/firefox-bin-${version}"

    mkdir -p "$out/bin"
    ln -s "$prefix/lib/firefox-bin-${version}/firefox" "$out/bin/${binaryName}"

    # See: https://github.com/mozilla/policy-templates/blob/master/README.md
    mkdir -p "$out/lib/firefox-bin-${version}/distribution";
    ln -s ${policiesJson} "$out/lib/firefox-bin-${version}/distribution/policies.json";
  '';

  passthru = {
    inherit binaryName;
    libName = "firefox-bin-${version}";
    ffmpegSupport = true;
    gssSupport = true;
    gtk3 = gtk3;

    # update with:
    # $ nix-shell maintainers/scripts/update.nix --argstr package firefox-bin-unwrapped
    updateScript = import ./update.nix {
      inherit
        pname
        channel
        lib
        writeScript
        xidel
        coreutils
        gnused
        gnugrep
        gnupg
        curl
        runtimeShell
        ;
      baseUrl =
        if channel == "developer-edition" then
          "https://archive.mozilla.org/pub/devedition/releases/"
        else
          "https://archive.mozilla.org/pub/firefox/releases/";
    };
  };

  meta = with lib; {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = "https://www.mozilla.org/firefox/";
    license = licenses.mpl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames mozillaPlatforms;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [
      taku0
      lovesegfault
    ];
    mainProgram = binaryName;
  };
}
