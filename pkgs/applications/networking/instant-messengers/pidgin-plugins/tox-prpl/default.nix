{ stdenv, fetchFromGitHub, libtoxcore, pidgin, autoreconfHook, libsodium }:

let
  version = "dd181722ea";
  date = "20141202";
in
stdenv.mkDerivation rec {
  name = "tox-prpl-${date}-${version}";

  src = fetchFromGitHub {
    owner = "jin-eld";
    repo = "tox-prpl";
    rev = "${version}";
    sha256 = "0wzyvg11h4ym28zqd24p35lza3siwm2519ga0yhk98rv458zks0v";
  };

  NIX_LDFLAGS = "-lssp -lsodium";

  postInstall = "mv $out/lib/purple-2 $out/lib/pidgin";

  buildInputs = [ libtoxcore pidgin autoreconfHook libsodium ];

  meta = {
    homepage = http://tox.dhs.org/;
    description = "Tox plugin for Pidgin / libpurple";
    license = stdenv.lib.licenses.gpl3;
  };
}
