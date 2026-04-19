{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "protonhax";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "jcnils";
    repo = pname;
    rev = version;
    sha256 = "sha256-5G4MCWuaF/adSc9kpW/4oDWFFRpviTKMXYAuT2sFf9w=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp protonhax $out/bin
  '';

  meta = with lib; {
    description = "Tool to help running other programs (i.e. Cheat Engine) inside Steam's proton";
    homepage = "https://github.com/jcnils/protonhax";
    changelog = "https://github.com/jcnils/protonhax/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smayzy ];
    mainProgram = "protonhax";
  };
}
