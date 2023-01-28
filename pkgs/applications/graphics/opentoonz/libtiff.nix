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
    knownVulnerabilities = [''
      Do not open untrusted files with Opentoonz:
      Opentoonz uses an old custom fork of tibtiff from 2012 that is known to
      be affected by at least these 50 vulnerabilities:
        CVE-2012-4564 CVE-2013-4232 CVE-2013-4243 CVE-2013-4244 CVE-2014-8127
        CVE-2014-8128 CVE-2014-8129 CVE-2014-8130 CVE-2014-9330 CVE-2015-1547
        CVE-2015-8781 CVE-2015-8782 CVE-2015-8783 CVE-2015-8784 CVE-2015-8870
        CVE-2016-3620 CVE-2016-3621 CVE-2016-3623 CVE-2016-3624 CVE-2016-3625
        CVE-2016-3631 CVE-2016-3632 CVE-2016-3633 CVE-2016-3634 CVE-2016-3658
        CVE-2016-3945 CVE-2016-3990 CVE-2016-3991 CVE-2016-5102 CVE-2016-5314
        CVE-2016-5315 CVE-2016-5316 CVE-2016-5318 CVE-2016-5319 CVE-2016-5321
        CVE-2016-5322 CVE-2016-5323 CVE-2016-6223 CVE-2016-9453 CVE-2016-9532
        CVE-2017-9935 CVE-2017-9937 CVE-2018-10963 CVE-2018-5360
        CVE-2019-14973 CVE-2019-17546 CVE-2020-35521 CVE-2020-35522
        CVE-2020-35523 CVE-2020-35524
      More info at https://github.com/opentoonz/opentoonz/issues/4193
    ''];
    maintainers = with lib.maintainers; [ chkno ];
  };
}
