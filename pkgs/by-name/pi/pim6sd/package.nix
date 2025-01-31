{ stdenv, fetchFromGitHub, lib, autoreconfHook, bison, flex }:

stdenv.mkDerivation rec {
  pname = "pim6sd";
  version = "unstable-2019-05-31";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "pim6sd";
    rev = "fa3909529981dd705ba9ead0517222c30c581a4e";
    sha256 = "0x7dyark2mp9xqz9cnmmgaf0z143vxn2835clllpji4ylg77zdjw";
  };

  nativeBuildInputs = [ autoreconfHook bison flex ];

  meta = with lib; {
    description = "PIM for IPv6 sparse mode daemon";
    homepage = "https://github.com/troglobit/pim6sd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/pim6sd.x86_64-darwin
  };
}
