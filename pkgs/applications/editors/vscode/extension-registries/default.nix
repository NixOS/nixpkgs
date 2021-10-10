{ lib, callPackage }:
{
  openvsx = lib.recurseIntoAttrs (callPackage ./openvsx { });
  standalone = lib.recurseIntoAttrs (callPackage ./standalone { });
  upstream-releases = lib.recurseIntoAttrs (callPackage ./upstream-releases { });
}
