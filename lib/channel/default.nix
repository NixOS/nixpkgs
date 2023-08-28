{ lib }:
{
  latestKnownNixOSChannelInfo = lib.importJSON ./pin.json;
}
