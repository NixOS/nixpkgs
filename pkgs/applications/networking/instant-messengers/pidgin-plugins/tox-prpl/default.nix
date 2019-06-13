{ stdenv, fetchFromGitHub, libtoxcore, pidgin, autoreconfHook, libsodium }:

stdenv.mkDerivation rec {
  name = "tox-prpl-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner  = "jin-eld";
    repo   = "tox-prpl";
    rev    = "v${version}";
    sha256 = "0ms367l2f7x83k407c93bmhpyc820f1css61fh2gx4jq13cxqq3p";
  };

  NIX_LDFLAGS = "-lssp -lsodium";

  postInstall = "mv $out/lib/purple-2 $out/lib/pidgin";

  buildInputs = [ libtoxcore pidgin libsodium ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jin-eld/tox-prpl;
    description = "Tox plugin for Pidgin / libpurple";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
