{ lib, callPackage }:
{
  standalone = lib.recurseIntoAttrs (callPackage ./standalone { });
  upstream-releases = lib.recurseIntoAttrs (callPackage ./upstream-releases { });
}
