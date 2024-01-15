{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "oed";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "oed";
    rev = "oed-${version}";
    hash = "sha256-ySfw8Xo/dCBd3K3dxWsdPz8gQ+KeXyReIlUo4q5SFCc=";
  };

  postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace configure --replace "./conftest" "echo"
  '';

  installPhase = ''
    install -m755 -Dt $out/bin ed
    install -m644 -Dt $out/share/man/man1 ed.1
  '';

  meta = with lib; {
    description = "Portable ed editor from OpenBSD";
    homepage = "https://github.com/ibara/oed";
    license = with licenses; [ bsd2 ];
    mainProgram = "ed";
    platforms = platforms.unix;
  };
}
