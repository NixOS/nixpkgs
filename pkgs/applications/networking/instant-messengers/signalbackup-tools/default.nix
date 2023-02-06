{ lib, stdenv, fetchFromGitHub, openssl, sqlite }:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20230206";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    sha256 = "sha256-i3I4VJ56YAwO4HG3mAhiQuR5jFCUpZ40hIpeflcLBhw=";
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
