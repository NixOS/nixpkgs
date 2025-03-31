{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "fpp";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "PathPicker";
    rev = version;
    sha256 = "sha256-4BkdGvG/RyF3JBnd/X5r5nboEHG4aqahcYHDunMv2zU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace fpp --replace 'PYTHONCMD="python3"' 'PYTHONCMD="${python3.interpreter}"'
  '';

  installPhase = ''
    mkdir -p $out/share/fpp $out/bin
    cp -r fpp src $out/share/fpp
    ln -s $out/share/fpp/fpp $out/bin/fpp
    installManPage debian/usr/share/man/man1/fpp.1
  '';

  meta = {
    description = "CLI program that accepts piped input and presents files for selection";
    homepage = "https://facebook.github.io/PathPicker/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "fpp";
  };
}
