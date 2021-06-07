# Per https://github.com/opentoonz/opentoonz/blob/master/doc/how_to_build_linux.md ,
# opentoonz requires its own modified version of libtiff.  We still build it as
# a separate package
#  1. For visibility for tools like vulnix, and
#  2. To avoid a diamond-dependency problem with opencv linking the normal libtiff
#     and opentoonz linking opencv and this modified libtiff, we build an opencv
#     against this modified libtiff as well.
#
# We use a separate mkDerivation rather than a minimal libtiff.overrideAttrs
# because the main libtiff builds with cmake and this version of libtiff was
# forked before libtiff gained CMake build capability (added in libtiff-4.0.5).

{ lib, fetchFromGitHub, stdenv, pkg-config, zlib, libjpeg, xz, libtiff, }:

let source = import ./source.nix { inherit fetchFromGitHub; };

in stdenv.mkDerivation {
  pname = "libtiff";
  version = source.versions.libtiff + "-opentoonz";

  inherit (source) src;
  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ zlib libjpeg xz ];

  postUnpack = ''
    sourceRoot="$sourceRoot/thirdparty/tiff-${source.versions.libtiff}"
  '';

  # opentoonz uses internal libtiff headers
  postInstall = ''
    cp libtiff/{tif_config,tif_dir,tiffiop}.h $dev/include
  '';

  meta = libtiff.meta // {
    maintainers = with lib.maintainers; [ chkno ];
  };
}
