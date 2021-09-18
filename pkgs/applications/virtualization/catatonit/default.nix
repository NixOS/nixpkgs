{ lib, stdenv, fetchFromGitHub, autoreconfHook, glibc, nixosTests }:

stdenv.mkDerivation rec {
  pname = "catatonit";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hokG6o7toZxU984EvIlne33Aa2EZVZ3qu1jTZMm5nt4=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  doInstallCheck = true;
  installCheckPhase = ''
    readelf -d $out/bin/catatonit | grep 'There is no dynamic section in this file.'
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "A container init that is so simple it's effectively brain-dead";
    homepage = "https://github.com/openSUSE/catatonit";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ erosennin ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
