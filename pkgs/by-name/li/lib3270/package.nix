{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  pkg-config,
  autoconf,
  automake,
  libtool,
  gettext,
  openssl,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "lib3270";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "PerryWerneck";
    repo = pname;
    rev = version;
    hash = "sha256-w6Bg+TvSDAuZwtu/nyAIuq6pgheM5nXtfuryECfnKng=";
  };

  nativeBuildInputs = [
    which
    pkg-config
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    gettext
    openssl
    curl
  ];

  postPatch = ''
    # Patch the required version.
    sed -i -e "s/20211118/19800101/" src/core/session.c
  '';

  preConfigure = ''
    NOCONFIGURE=1 sh autogen.sh
  '';

  enableParallelBuilds = true;

  meta = with lib; {
    description = "TN3270 client Library";
    homepage = "https://github.com/PerryWerneck/lib3270";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.vifino ];
  };
}
