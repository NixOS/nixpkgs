{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  callPackage,
  fetchurl,
}:
let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  src =
    fetchurl
      sources.sources.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  version = sources.version;

  meta = {
    description = "Atlassian Command Line Interface";
    homepage = "https://developer.atlassian.com/cloud/acli/guides/introduction";
    maintainers = with lib.maintainers; [ moraxyc ];
    platforms = lib.attrNames sources.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "acli";
  };

  updateScript = ./update.py;

  unwrapped = callPackage ./unwrapped.nix {
    inherit
      src
      version
      meta
      updateScript
      ;
  };
  wrapped = buildFHSEnv {
    pname = "acli";
    inherit version;

    targetPkgs =
      p: with p; [
        unwrapped

        cacert
        openssl

        # For rovodev
        zlib
        libffi
        sqlite
      ];

    runScript = "acli";

    passthru = {
      inherit unwrapped updateScript;
    };

    inherit meta;
  };
in
if stdenvNoCC.hostPlatform.isLinux then wrapped else unwrapped.override { pname = "acli"; }
