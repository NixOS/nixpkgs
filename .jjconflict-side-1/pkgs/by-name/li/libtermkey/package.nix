{ stdenv, lib, fetchzip, libtool, pkg-config, ncurses, unibilium }:

stdenv.mkDerivation rec {
  pname = "libtermkey";
  version = "0.22";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/libtermkey-${version}.tar.gz";
    sha256 = "02dks6bj7n23lj005yq41azf95wh3hapmgc2lzyh12vigkjh67rg";
  };

  makeFlags = [ "PREFIX=$(out)" "LIBTOOL=${libtool}/bin/libtool" ];

  nativeBuildInputs = [ libtool pkg-config ];
  buildInputs = [ ncurses unibilium ];

  strictDeps = true;

  meta = with lib; {
    description = "Terminal keypress reading library";
    homepage = "http://www.leonerd.org.uk/code/libtermkey";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
