{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hexbinhex";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "dj-on-github";
    repo = "hexbinhex";
    rev = "v${version}";
    hash = "sha256-nfOmiF+t5QtAl1I7CSz26C9SGo7ZkdSziO2eiHbk6pA=";
  };

  preBuild =
    ''
      substituteInPlace Makefile --replace '/usr/local' $out
      mkdir -p $out/bin
    ''
    + lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
      sed -i s/-m64//g Makefile
    '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/dj-on-github/hexbinhex";
    description = ''
      Six utility programs to convert between hex, binary, ascii-binary
      and the oddball NIST format for 90B testing.
    '';
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      orichter
      thillux
    ];
  };
}
