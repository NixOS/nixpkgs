{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "protonhax";
  version = "1.0.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jcnils";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-5G4MCWuaF/adSc9kpW/4oDWFFRpviTKMXYAuT2sFf9w=";
  };

  patchPhase = ''
    patchShebangs protonhax
  '';

  installPhase = ''
    install -Dm755 protonhax $out/bin/protonhax
  '';

  meta = with lib; {
    description = "Tool to help running other programs (i.e. Cheat Engine) inside Steam's proton";
    homepage = "https://github.com/jcnils/protonhax";
    changelog = "https://github.com/jcnils/protonhax/releases/tag/${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smayzy ];
    mainProgram = "protonhax";
  };
})
