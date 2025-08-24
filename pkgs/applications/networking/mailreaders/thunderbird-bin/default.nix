# Update instructions:
#
# To update `thunderbird-bin`'s `release_sources.nix`, run from the nixpkgs root:
#
#     nix-shell maintainers/scripts/update.nix --argstr package pkgs.thunderbird-bin-unwrapped
#     nix-shell maintainers/scripts/update.nix --argstr package pkgs.thunderbird-esr-bin-unwrapped
{
  lib,
  stdenv,
  fetchurl,
  config,
  wrapGAppsHook3,
  autoPatchelfHook,
  alsa-lib,
  curl,
  gtk3,
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
  generated,
  versionSuffix ? "",
  applicationName ? "Thunderbird",
}:

let
  inherit (generated) version sources;

  mozillaPlatforms = {
    i686-linux = "linux-i686";
    x86_64-linux = "linux-x86_64";
  };

  arch = mozillaPlatforms.${stdenv.hostPlatform.system};

  isPrefixOf = prefix: string: builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source: (isPrefixOf source.locale locale) && source.arch == arch;

  policies = {
    DisableAppUpdate = true;
  }
  // config.thunderbird.policies or { };
  policiesJson = writeText "thunderbird-policies.json" (builtins.toJSON { inherit policies; });

  defaultSource = lib.findFirst (sourceMatches "en-US") { } sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia" then
      "ca-valencia"
    else
      lib.replaceStrings [ "_" ] [ "-" ] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  pname = "thunderbird-bin";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    inherit (source) url sha256;
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
    patchelfUnstable
  ];
  buildInputs = [
    alsa-lib
  ];
  # Thunderbird uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  patchPhase = ''
    # Don't download updates from Mozilla directly
    echo 'pref("app.update.auto", "false");' >> defaults/pref/channel-prefs.js
  '';

  installPhase = ''
    mkdir -p "$prefix/usr/lib/thunderbird-bin-${version}"
    cp -r * "$prefix/usr/lib/thunderbird-bin-${version}"

    mkdir -p "$out/bin"
    ln -s "$prefix/usr/lib/thunderbird-bin-${version}/thunderbird" "$out/bin/"

    # wrapThunderbird expects "$out/lib" instead of "$out/usr/lib"
    ln -s "$out/usr/lib" "$out/lib"

    gappsWrapperArgs+=(--argv0 "$out/bin/.thunderbird-wrapped")

    # See: https://github.com/mozilla/policy-templates/blob/master/README.md
    mkdir -p "$out/lib/thunderbird-bin-${version}/distribution";
    ln -s ${policiesJson} "$out/lib/thunderbird-bin-${version}/distribution/policies.json";
  '';

  passthru.updateScript = import ./../../browsers/firefox-bin/update.nix {
    inherit
      pname
      writeScript
      xidel
      coreutils
      gnused
      gnugrep
      curl
      gnupg
      runtimeShell
      versionSuffix
      ;
    baseName = "thunderbird";
    basePath = "pkgs/applications/networking/mailreaders/thunderbird-bin";
    baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
  };

  passthru = {
    inherit applicationName;
    binaryName = "thunderbird";
    gssSupport = true;
    gtk3 = gtk3;
  };

  meta = {
    changelog = "https://www.thunderbird.net/en-US/thunderbird/${version}/releasenotes/";
    description = "Mozilla Thunderbird, a full-featured email client (binary package)";
    homepage = "http://www.mozilla.org/thunderbird/";
    mainProgram = "thunderbird";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ lovesegfault ];
    platforms = builtins.attrNames mozillaPlatforms;
    hydraPlatforms = [ ];
  };
}
