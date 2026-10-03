{
  fetchFromGitHub,
  lib,
  stdenv,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doona";
  version = "0-unstable-2019-03-08";

  src = fetchFromGitHub {
    owner = "wireghoul";
    repo = "doona";
    rev = "master";
    hash = "sha256-4W97FAGznErkybWpuWOI7WVMc1NQPwOZUVH0wjPPMXU=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r ${finalAttrs.src}/bedmod $out/bin/bedmod
    cp ${finalAttrs.src}/doona.pl $out/bin/doona
    chmod +x $out/bin/doona
  '';

  meta = {
    homepage = "https://github.com/wireghoul/doona";
    description = "Fork of the Bruteforce Exploit Detector Tool (BED)";
    mainProgram = "doona";
    longDescription = ''
      A fork of the Bruteforce Exploit Detector Tool (BED).
      BED is a program which is designed to check daemons for potential buffer overflows, format string bugs etc.
    '';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pamplemousse ];
  };
})
