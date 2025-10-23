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
  applicationName ? "Firefox",
  undmg,
}:

let

  inherit (generated) version sources;

  binaryName = "firefox";

  mozillaPlatforms = {
    i686-linux = "linux-i686";
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
    # bundles are universal and can be re-used for both darwin architectures
    aarch64-darwin = "mac";
    x86_64-darwin = "mac";
  };

  arch = mozillaPlatforms.${stdenv.hostPlatform.system};

  isPrefixOf = prefix: string: builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source: (isPrefixOf source.locale locale) && source.arch == arch;

  policies = {
    DisableAppUpdate = true;
  }
  // config.firefox.policies or { };

  policiesJson = writeText "firefox-policies.json" (builtins.toJSON { inherit policies; });

  defaultSource = lib.findFirst (sourceMatches "en-US") { } sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia" then
      "ca-valencia"
    else
      lib.replaceStrings [ "_" ] [ "-" ] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  pname = "firefox-bin-unwrapped";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl { inherit (source) url sha256; };

  sourceRoot = lib.optional stdenv.hostPlatform.isDarwin ".";

  nativeBuildInputs = [
    wrapGAppsHook3
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    autoPatchelfHook
    patchelfUnstable
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    undmg
  ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gtk3
    adwaita-icon-theme
    alsa-lib
    dbus-glib
    libXtst
  ];
  runtimeDependencies = [
    curl
    pciutils
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libva.out
  ];
  appendRunpaths = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "${pipewire}/lib"
  ];
  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  # don't break code signing
  dontFixup = stdenv.hostPlatform.isDarwin;

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv Firefox*.app "$out/Applications/${applicationName}.app"
      ''
    else
      ''
        mkdir -p "$prefix/lib/firefox-bin-${version}"
        cp -r * "$prefix/lib/firefox-bin-${version}"

        mkdir -p "$out/bin"
        ln -s "$prefix/lib/firefox-bin-${version}/firefox" "$out/bin/${binaryName}"

        # See: https://github.com/mozilla/policy-templates/blob/master/README.md
        mkdir -p "$out/lib/firefox-bin-${version}/distribution";
        ln -s ${policiesJson} "$out/lib/firefox-bin-${version}/distribution/policies.json";
      '';

  passthru = {
    inherit applicationName binaryName;
    libName = "firefox-bin-${version}";
    ffmpegSupport = true;
    gssSupport = true;
    gtk3 = gtk3;

    # update with:
    # $ nix-shell maintainers/scripts/update.nix --argstr package firefox-bin-unwrapped
    updateScript = import ./update.nix {
      inherit
        pname
        writeScript
        xidel
        coreutils
        gnused
        gnugrep
        gnupg
        curl
        runtimeShell
        ;
      baseUrl = "https://archive.mozilla.org/pub/firefox/releases/";
    };
  };

  meta = {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = "https://www.mozilla.org/firefox/";
    license = {
      shortName = "firefox";
      fullName = "Firefox Terms of Use";
      url = "https://www.mozilla.org/about/legal/terms/firefox/";
      # "You Are Responsible for the Consequences of Your Use of Firefox"
      # (despite the heading, not an indemnity clause) states the following:
      #
      # > You agree that you will not use Firefox to infringe anyone’s rights
      # > or violate any applicable laws or regulations.
      # >
      # > You will not do anything that interferes with or disrupts Mozilla’s
      # > services or products (or the servers and networks which are connected
      # > to Mozilla’s services).
      #
      # This conflicts with FSF freedom 0: "The freedom to run the program as
      # you wish, for any purpose". (Why should Mozilla be involved in
      # instances where you break your local laws just because you happen to
      # use Firefox whilst doing it?)
      free = false;
      redistributable = true; # since MPL-2.0 still applies
    };
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames mozillaPlatforms;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [
      taku0
      lovesegfault
    ];
    mainProgram = binaryName;
  };
}
