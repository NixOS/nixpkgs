{
  # keep-sorted start
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  musl,
  stdenv,
  # keep-sorted end
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.2.3.tar.gz";
      hash = "sha256-2frTIFkvrCXkR1PvA6j2iob3714Oif/IaZGwRnsae4c=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.2.3-aarch64.tar.gz";
      hash = "sha256-mDeMiX3IviQ4xPzMOj5tw87krP0aVEArXDqSqFb8/WY=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2026.2.3-aarch64.dmg";
      hash = "sha256-kgetXR/G4rb6BvtvQbgk5kWW4bFkdd8i8OIHplT433M=";
    };
  };
  # update-script-end: urls
in
jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;

  pname = "phpstorm";

  wmClass = "jetbrains-phpstorm";
  product = "PhpStorm";

  # update-script-start: version
  version = "2026.2.3";
  buildNumber = "262.10968.76";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/phpstorm/";
    description = "PHP IDE from JetBrains";
    longDescription = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code.";
    maintainers = with lib.maintainers; [ tymscar ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
