{lib, stdenv, fetchFromGitea, autoconf-archive, autoreconfHook, pkg-config, libstrophe, glib, gpgme }:

stdenv.mkDerivation rec {
  pname = "xmppc";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Anoxinon_e.V.";
    repo = "xmppc";
    rev = version;
    sha256 = "07cy3j4g7vycagdiva3dqb59361lw7s5f2yydpczmyih29v7hkm8";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libstrophe
    glib
    gpgme
  ];

  preAutoreconf = ''
    mkdir m4
  '';

  meta = with lib; {
    description = "Command Line Interface Tool for XMPP";
    mainProgram = "xmppc";
    homepage = "https://codeberg.org/Anoxinon_e.V./xmppc";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.jugendhacker ];
  };
}
