# not a stable interface, do not reference outside the goose-cli package but make a
# copy if you need
{
  lib,
  stdenv,
  fetchurl,
}:

{
  fetchLibrustyV8 =
    args:
    let
      archivePrefix = args.archivePrefix or "librusty_v8_release";
    in
    fetchurl {
      name = "librusty_v8-${args.version}";
      url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/${archivePrefix}_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
      sha256 = args.shas.${stdenv.hostPlatform.system};
      meta = {
        inherit (args) version;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    };
}
