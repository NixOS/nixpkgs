{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "protonhax";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "jcnils";
    repo = "protonhax";
    rev = "922a7bbade5a93232b3152cc20a7d8422db09c31";
    hash = "sha256-5G4MCWuaF/adSc9kpW/4oDWFFRpviTKMXYAuT2sFf9w=";
  };

  meta = {
    description = "Run programs inside your game proton's environment";
    homepage = "https://github.com/jcnils/protonhax";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shringe ];
    mainProgram = "protonhax";
    platforms = lib.platforms.all;
  };

  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp protonhax $out/bin/protonhax

    wrapProgram $out/bin/protonhax \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';
}
