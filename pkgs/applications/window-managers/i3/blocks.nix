{ fetchFromGitHub, stdenv, autoreconfHook }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "i3blocks-${version}";
  version = "unstable-2019-02-07";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks";
    rev = "ec050e79ad8489a6f8deb37d4c20ab10729c25c3";
    sha256 = "1fx4230lmqa5rpzph68dwnpcjfaaqv5gfkradcr85hd1z8d1qp1b";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "A flexible scheduler for your i3bar blocks";
    homepage = https://github.com/vivien/i3blocks;
    license = licenses.gpl3;
    platforms = with platforms; freebsd ++ linux;
  };
}
