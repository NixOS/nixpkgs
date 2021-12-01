# Per https://github.com/opentoonz/opentoonz/blob/master/doc/how_to_build_linux.md ,
# opentoonz requires its own modified version of libtiff.  We still build it as
# a separate package
#  1. For visibility for tools like vulnix, and
#  2. To avoid a diamond-dependency problem with qt linking the normal libtiff
#     and opentoonz linking qt and this modified libtiff, we build a qt against
#     this modified libtiff as well.

{ fetchFromGitHub, libtiff }:
let source = import ./source.nix { inherit fetchFromGitHub; };
in libtiff.overrideAttrs (old: {
  inherit (source) src;
  version = source.versions.libtiff + "-opentoonz";
  postUnpack = (old.postUnpack or "") + ''
    sourceRoot="$sourceRoot/thirdparty/tiff-${source.versions.libtiff}"
  '';
  # opentoonz uses internal libtiff headers
  postInstall = (old.postInstall or "") + ''
    cp libtiff/{tif_config,tif_dir,tiffiop}.h $dev/include
  '';
})
