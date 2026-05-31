{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bmfdec";
  version = "0-unstable-2023-04-16";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "pali";
    repo = "bmfdec";
    rev = "c7b72f6ece126a8f686d66402009a14cb032a769";
    hash = "sha256-6qQS6SpLiRzCt02RyGYZUDjt/CNp8DoCH/RG89GX/dE=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin bmfdec bmfparse bmf2mof
    runHook postInstall
  '';

  meta = {
    description = "Decompile binary MOF file (BMF) from WMI buffer";
    homepage = "https://github.com/pali/bmfdec";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.nikableh ];
  };
})
