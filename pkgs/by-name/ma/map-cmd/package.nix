{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "map";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "map";
    rev = finalAttrs.version;
    sha256 = "sha256-yGzmhZwv1qKy0JNcSzqL996APQO8OGWQ1GBkEkKTOXA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p "$out/share/doc/map"
    cp README* LICENSE "$out/share/doc/map"
  '';

  doCheck = true;

  checkPhase = "./test/tests.sh";

  meta = {
    description = "Map lines from stdin to commands";
    mainProgram = "map";
    homepage = "https://github.com/soveran/map";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pogobanane ];
    platforms = lib.platforms.unix;
  };
})
