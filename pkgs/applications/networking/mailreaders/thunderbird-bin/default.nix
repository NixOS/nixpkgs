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
  curl,
  gtk3,
  writeScript,
  xidel,
  coreutils,
  gnused,
  gnugrep,
  gnupg,
  runtimeShell,
  systemLocale ? config.i18n.defaultLocale or "en_US",
  generated,
  versionSuffix ? "",
  applicationName ? "Thunderbird",
  # linux dependencies
  writeText,
  autoPatchelfHook,
  patchelfUnstable,
  alsa-lib,
  # darwin dependencies
  undmg,
}:

let
  inherit (generated) version sources;

  pname = "thunderbird-bin";

  mozillaPlatforms = {
    x86_64-linux = "linux-x86_64";
    # bundles are universal and can be re-used for both darwin architectures
    aarch64-darwin = "mac";
    x86_64-darwin = "mac";
  };

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  arch = mozillaPlatforms.${stdenv.hostPlatform.system} or throwSystem;

  isPrefixOf = prefix: string: builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source: (isPrefixOf source.locale locale) && source.arch == arch;

  defaultSource = lib.findFirst (sourceMatches "en-US") { } sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia" then
      "ca-valencia"
    else
      lib.replaceStrings [ "_" ] [ "-" ] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  src = fetchurl {
    inherit (source) url sha256;
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

  updateScript = import ./../../browsers/firefox-bin/update.nix {
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

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  passthru = {
    inherit
      applicationName
      updateScript
      gtk3
      ;
    binaryName = "thunderbird";
    gssSupport = true;
  };

in
if stdenv.hostPlatform.isDarwin then
  import ./darwin.nix {
    inherit
      pname
      version
      src
      nativeBuildInputs
      passthru
      meta
      stdenv
      undmg
      ;
  }
else
  import ./linux.nix {
    inherit
      pname
      version
      src
      nativeBuildInputs
      passthru
      meta
      stdenv
      config
      writeText
      autoPatchelfHook
      patchelfUnstable
      alsa-lib
      ;
  }
