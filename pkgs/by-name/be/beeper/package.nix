{
  lib,
  callPackage,
  fetchurl,
  stdenvNoCC,
}:
let
  inherit (stdenvNoCC.hostPlatform) isDarwin system;
  sources = import ./sources.nix { inherit fetchurl; };
  inherit (sources.${system}) src version;
in
callPackage (if isDarwin then ./darwin.nix else ./linux.nix) {
  inherit src version;
  pname = "beeper";
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Universal chat app";
    longDescription = ''
      Beeper is a universal chat app. With Beeper, you can send
      and receive messages to friends, family and colleagues on
      many different chat networks.
    '';
    homepage = "https://beeper.com";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      jshcmpbll
      zh4ngx
    ];
    platforms = builtins.attrNames sources;
  };
}
