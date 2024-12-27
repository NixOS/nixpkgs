{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "er-patcher";
  version = "1.12-3";

  src = fetchFromGitHub {
    owner = "gurrgur";
    repo = "er-patcher";
    rev = "v${version}";
    sha256 = "sha256-D+XYZI3kmK5sb+i8RxtODTvbTgzhpDzwB/JM61ddcTA=";
  };

  buildInputs = [
    python3
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src/er-patcher $out/bin/er-patcher
    patchShebangs $out/bin/er-patcher
  '';

  meta = with lib; {
    homepage = "https://github.com/gurrgur/er-patcher";
    changelog = "https://github.com/gurrgur/er-patcher/releases/tag/v${version}";
    description = "Enhancement patches for Elden Ring adding ultrawide support, custom frame rate limits and more";
    longDescription = ''
      A tool aimed at enhancing the experience when playing the game on linux through proton or natively on windows.
      This tool is based on patching the game executable through hex-edits. However it is done in a safe and non-destructive way,
      that ensures the patched executable is never run with EAC enabled (unless explicity told to do so). Use at your own risk!
    '';
    license = licenses.mit;
    maintainers = [ lib.maintainers.sigmasquadron ];
    mainProgram = "er-patcher";
  };
}
