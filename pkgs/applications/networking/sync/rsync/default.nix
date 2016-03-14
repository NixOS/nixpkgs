{ stdenv, fetchurl, perl
, enableACLs ? true, acl ? null
, enableCopyDevicesPatch ? false
}:

assert enableACLs -> acl != null;

let
  base = import ./base.nix { inherit stdenv fetchurl; };
in
stdenv.mkDerivation rec {
  name = "rsync-${base.version}";

  mainSrc = base.src;

  patchesSrc = base.patches;

  srcs = [mainSrc] ++ stdenv.lib.optional enableCopyDevicesPatch patchesSrc;
  patches = stdenv.lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

  buildInputs = stdenv.lib.optional enableACLs acl;
  nativeBuildInputs = [perl];

  configureFlags = "--with-nobody-group=nogroup";

  meta = base.meta // {
    description = "A fast incremental file transfer utility";
    maintainers = with stdenv.lib.maintainers; [ simons ehmry kampfschlaefer ];
  };
}
