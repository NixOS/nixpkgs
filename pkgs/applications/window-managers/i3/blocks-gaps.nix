{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  name = "i3blocks-gaps-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Airblader";
    repo = "i3blocks-gaps";
    rev = "4cfdf93c75f729a2c96d471004d31734e923812f";
    sha256 = "0v9307ij8xzwdaxay3r75sd2cp453s3qb6q7dy9fks2p6wwqpazi";
  };

  makeFlags = "all";
  installFlags = "PREFIX=\${out} VERSION=${version}";

  meta = with stdenv.lib; {
    description = "A flexible scheduler for your i3bar blocks -- this is a fork to use with i3-gaps";
    homepage = https://github.com/Airblader/i3blocks-gaps;
    license = licenses.gpl3;
    maintainers = [ "carlsverre" ];
    platforms = platforms.linux;
  };
}
