{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "oed";
  version = "6.7";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "oed";
    rev = "oed-${version}";
    hash = "sha256-Z8B1RIFve3UPj+9G/WJX0BNc2ynG/qtoGfoesarYGz8=";
  };

  postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace configure --replace "./conftest" "echo"
  '';

  installPhase = ''
    install -m755 -Dt $out/bin ed
    install -m644 -Dt $out/share/man/man1 ed.1
  '';

  meta = with lib; {
    homepage = "https://github.com/ibara/oed";
    description = "Portable ed editor from OpenBSD";
    license = with licenses; [ bsd2 ];
    platforms = platforms.unix;
  };
}
