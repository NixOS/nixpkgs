{ stdenv, fetchurl, perl, libiconv, zlib, popt
, enableACLs ? true, acl ? null
, enableCopyDevicesPatch ? false
, enableIgnoreCasePatch  ? true
}:

assert enableACLs -> acl != null;

let
  base = import ./base.nix { inherit stdenv fetchurl; };
in
stdenv.mkDerivation rec {
  name = "rsync-${base.version}";

  mainSrc = base.src;

  patchesSrc = base.upstreamPatchTarball;

  srcs = [mainSrc patchesSrc];
  patches = stdenv.lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff"
    ++ stdenv.lib.optional enableIgnoreCasePatch "./patches/ignore-case.diff";

  buildInputs = [libiconv zlib popt] ++ stdenv.lib.optional enableACLs acl;
  nativeBuildInputs = [perl];

  configureFlags = ["--with-nobody-group=nogroup"];

  meta = base.meta // {
    description = "A fast incremental file transfer utility";
    maintainers = with stdenv.lib.maintainers; [ peti ehmry kampfschlaefer ];
  };
}
