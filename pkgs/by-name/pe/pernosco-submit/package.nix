{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,

  python3,
  awscli2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pernosco-submit";
  version = "0-unstable-2025-10-04";

  src = fetchFromGitHub {
    owner = "Pernosco";
    repo = "pernosco-submit";
    rev = "66f9a1680bd1a5358c60a39c1c8c4c6460f5c7bd";
    hash = "sha256-4ehiU/8hPZMD8ElFnrE/EtW3pom9AcXWE5voCTvhGaw=";
  };

  buildInputs = [
    python3
    awscli2
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    # Copy pernosco-submit source code
    mkdir -p $out/share
    cp -r . $out/share/pernosco-submit

    # Patch shebang & PATH
    patchShebangs --host $out/share/pernosco-submit/pernosco-submit
    makeWrapper $out/share/pernosco-submit/pernosco-submit $out/share/pernosco-submit/.pernosco-submit-wrapped \
      --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}

    # Create a symlink
    mkdir -p $out/bin
    ln -s $out/share/pernosco-submit/.pernosco-submit-wrapped $out/bin/pernosco-submit
  '';

  meta = {
    description = "Tool for submitting traces to Pernosco";
    homepage = "https://github.com/Pernosco/pernosco-submit";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "pernosco-submit";
  };
})
