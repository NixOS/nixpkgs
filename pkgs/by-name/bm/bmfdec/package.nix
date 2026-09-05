{
  lib,
  stdenv,
  gnumake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "bmfdec";
  version = "0-unstable-2023-04-16";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "bmfdec";
    rev = "c7b72f6ece126a8f686d66402009a14cb032a769";
    hash = "sha256-6qQS6SpLiRzCt02RyGYZUDjt/CNp8DoCH/RG89GX/dE=";
  };

  installPhase = ''
    find . \
      -type f -executable \
      -exec install -D {} $out/bin/{} \;
  '';

  meta = {
    description = "Decompile binary MOF file (BMF) from WMI buffer";
    homepage = "https://github.com/pali/bmfdec";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sielicki ];
    mainProgram = "bmfdec";
  };
}
