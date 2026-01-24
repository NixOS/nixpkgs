{ stdenv
, lib
, fetchgit
}:
stdenv.mkDerivation rec {
  pname = "nututils";
  version = "unstable-2020-11-06";

  src = fetchgit {
    url = "https://git.ffmpeg.org/nut.git";
    rev = "12f6a7af3e0f34fd957cf078b66f072d3dc695b3";
    hash = "sha256-MlBSIQd3JklrtnImDmta72jpaBQbMOWHDEwgklYV9PE=";
  };

  sourceRoot = "${src.name}/src/trunk";
  patches = [ ./prefix.patch ];
  dontConfigure = true;
  makeFlags = [ "prefix=$(out)" ];
  installTargets = "install-nututils";

  meta = {
    description = "Utils for the NUT video container format";
    homepage = "https://git.ffmpeg.org/gitweb/nut.git";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.quag ];
    platforms = lib.platforms.linux;
  };
}
