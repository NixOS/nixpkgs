{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  mp4v2Support ? true,
  mp4v2,
  drmSupport ? false, # Digital Radio Mondiale
}:

stdenv.mkDerivation rec {
  pname = "faac";
  version = "1.30";

  src = fetchurl {
    url = "mirror://sourceforge/faac/${pname}-${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }.tar.gz";
    sha256 = "1lmj0dib3mjp84jhxc5ddvydkzzhb0gfrdh3ikcidjlcb378ghxd";
  };

  configureFlags =
    lib.optional mp4v2Support "--with-external-mp4v2"
    ++ lib.optional drmSupport "--enable-drm";

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optional mp4v2Support mp4v2;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage = "https://github.com/knik0/faac";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
