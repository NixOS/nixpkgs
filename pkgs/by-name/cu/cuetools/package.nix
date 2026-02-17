{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flac,
  flex,
  id3v2,
  vorbis-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cuetools";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "svend";
    repo = "cuetools";
    rev = finalAttrs.version;
    sha256 = "02ksv1ahf1v4cr2xbclsfv5x17m9ivzbssb5r8xjm97yh8a7spa3";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    bison
    flac
    flex
    id3v2
    vorbis-tools
  ];

  postInstall = ''
    # add link for compatibility with Debian-based distros, which package `cuetag.sh` as `cuetag`
    ln -s $out/bin/cuetag.sh $out/bin/cuetag
  '';

  meta = {
    description = "Set of utilities for working with cue files and toc files";
    homepage = "https://github.com/svend/cuetools";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      codyopel
      jcumming
    ];
    platforms = lib.platforms.all;
  };
})
