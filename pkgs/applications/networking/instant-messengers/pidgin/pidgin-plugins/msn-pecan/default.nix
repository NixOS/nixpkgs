{ lib, stdenv, fetchFromGitHub, pidgin} :

stdenv.mkDerivation rec {
  pname = "pidgin-msn-pecan";
  version = "0.1.4";
  src = fetchFromGitHub {
    owner = "felipec";
    repo = "msn-pecan";
    rev = "v${version}";
    sha256 = "0133rpiy4ik6rx9qn8m38vp7w505hnycggr53g3a2hfpk5xj03zh";
  };

  meta = {
    description = "Alternative MSN protocol plug-in for Pidgin IM";
    homepage = "https://github.com/felipec/msn-pecan";
    platforms = lib.platforms.linux;
  };

  makeFlags = [
    "PURPLE_LIBDIR=${placeholder "out"}/lib"
    "PURPLE_DATADIR=${placeholder "out"}/share/data"
  ];

  buildInputs = [pidgin];
}
