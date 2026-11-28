{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  perl,
}:
let
  escapeMakeFlag = builtins.replaceStrings [ "\$" ] [ "\$\$" ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "scram";
  version = "2.2.9-pre14";

  __structuredAttrs = true;

  SCRAM_VERSION = "V${lib.replaceStrings [ "." "-" ] [ "_" "_" ] finalAttrs.version}";

  src = fetchFromGitHub {
    owner = "cms-sw";
    repo = "SCRAM";
    rev = finalAttrs.SCRAM_VERSION;
    hash = "sha256-k5XoLNGIfFKWlYrZHFK9hrYojA8SsjSM650BQEgDtfQ=";
  };

  # Name of the environment variable to get CMS_PATH from.
  # If null, get directly from CMS_PATH specified by overrideAttrs.
  getCmsPathFromEnv = "CMS_PATH";

  postPatch = lib.optionalString (finalAttrs.getCmsPathFromEnv != null) ''
    substituteInPlace "bin/scram.in" --replace "'@CMS_PATH@'" "@CMS_PATH@"
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeFlagAttrs = {
    VERSION = finalAttrs.SCRAM_VERSION;
    # The surrounding double-quotes ("...") is to get it out of the outer double-quotes
    # Get from environment variable CMS_PATH if finalAttrs.getCmsPathFromEnv
    # otherwise get from finalAttrs.CMS_PATH
    INSTALL_BASE = escapeMakeFlag "\"${
      lib.escapeShellArg (
        if finalAttrs.getCmsPathFromEnv != null then
          "\$ENV{'${finalAttrs.getCmsPathFromEnv}'}"
        else
          finalAttrs.CMS_PATH
      )
    }\"";
    PREFIX = "${placeholder "out"}/libexec/scramv2";
  };

  makeFlags = lib.mapAttrsToList (name: value: "${name}=${value}") finalAttrs.makeFlagAttrs;

  preBuild = ''
    mkdir -p "''${makeFlagAttrs[PREFIX]}"
  '';

  postInstall = ''
    mkdir -p "$out/bin"
    makeWrapper "''${makeFlagAttrs[PREFIX]}/bin/chktool" "$out/bin/chktool"
    makeWrapper "''${makeFlagAttrs[PREFIX]}/bin/scram" "$out/bin/scramv2"
    ln -s "$out/bin/scramv2" "$out/bin/scram"
  '';

  meta = with lib; {
    description = "Software Configuration And Management - CMS internal build tool";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
    mainProgram = "scram";
  };
})
