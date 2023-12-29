{ lib, stdenv, fetchFromGitHub, openssl, sqlite }:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20231226";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    hash = "sha256-8/jhRfA8fLoTYUuLxuxUEzDkjZYLfECLyc13iLIaW/Y=";
  };

  postPatch = ''
    patchShebangs BUILDSCRIPT_MULTIPROC.bash44
  '';

  buildInputs = [ openssl sqlite ];

  buildPhase = ''
    runHook preBuild
    ./BUILDSCRIPT_MULTIPROC.bash44${lib.optionalString stdenv.isDarwin " --config nixpkgs-darwin"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
