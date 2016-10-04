{ stdenv, fetchFromGitHub, xlibsWrapper, motif }:

stdenv.mkDerivation rec {
  name = "catclock-2015-10-04";

  src = fetchFromGitHub {
    owner = "BarkyTheDog";
    repo = "catclock";
    rev = "d20b8825b38477a144e8a2a4bbd4779adb3620ac";
    sha256 = "0fiv9rj8p8mifv24cxljdrrmh357q70zmzdci9bpbxnhs1gdpr63";
  };

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp xclock.man $out/share/man/man1/xclock.1
  '';

  makeFlags = [
    "DESTINATION=$(out)/bin/"
  ];

  buildInputs = [ xlibsWrapper motif ];

  meta = with stdenv.lib; {
    homepage = http://codefromabove.com/2014/05/catclock/;
    license = with licenses; mit;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux ++ darwin;
  };
}
