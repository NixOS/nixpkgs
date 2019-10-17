{ fetchFromGitHub, fetchpatch, stdenv, autoreconfHook }:

with stdenv.lib;

stdenv.mkDerivation {
  pname = "i3blocks";
  version = "unstable-2019-02-07";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks";
    rev = "ec050e79ad8489a6f8deb37d4c20ab10729c25c3";
    sha256 = "1fx4230lmqa5rpzph68dwnpcjfaaqv5gfkradcr85hd1z8d1qp1b";
  };

  patches = [
    # XDG_CONFIG_DIRS can contain multiple elements separated by colons, which should be searched in order.
    (fetchpatch {
      # https://github.com/vivien/i3blocks/pull/405
      url = https://github.com/edef1c/i3blocks/commit/d57b32f9a364aeaf36869efdd54240433c737e57.patch;
      sha256 = "102xb0ax0hmg82dz2gzfag470dkckzf2yizai0izacvrz0d3ngj1";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "A flexible scheduler for your i3bar blocks";
    homepage = https://github.com/vivien/i3blocks;
    license = licenses.gpl3;
    platforms = with platforms; freebsd ++ linux;
  };
}
