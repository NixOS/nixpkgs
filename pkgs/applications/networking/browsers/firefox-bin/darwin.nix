{ lib
, stdenv
, fetchurl
, config
, curl
, channel
, generated
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, gnupg
, undmg
, runtimeShell
, systemLocale ? config.i18n.defaultLocale or "en_US"
}:

let
  inherit (generated) version sources;

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == "mac";

  defaultSource = lib.findFirst (sourceMatches "en-US") {} sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia"
    then "ca-valencia"
    else lib.replaceStrings ["_"] ["-"] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  src = fetchurl { inherit (source) url sha256; };

  pname = "firefox-${channel}-bin-unwrapped";

  # update with:
  # $ nix-shell maintainers/scripts/update.nix --argstr package firefox-bin-unwrapped
  updateScript = import ./update.nix {
    inherit pname channel lib writeScript xidel coreutils gnused gnugrep gnupg curl runtimeShell;
    baseUrl =
      if channel == "devedition"
        then "https://archive.mozilla.org/pub/devedition/releases/"
        else "https://archive.mozilla.org/pub/firefox/releases/";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  passthru = {
    inherit updateScript;
  };

  meta = with lib; {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = "https://www.mozilla.org/firefox/";
    license = licenses.mpl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ taku0 lovesegfault ];
  };
}
