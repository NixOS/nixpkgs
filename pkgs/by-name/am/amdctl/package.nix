{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "amdctl";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "kevinlekiller";
    repo = "amdctl";
    tag = "v${version}";
    hash = "sha256-2wBk/9aAD7ARMGbcVxk+CzEvUf8U4RS4ZwTCj8cHNNo=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 amdctl $out/bin/amdctl

    runHook postInstall
  '';

  meta = with lib; {
    description = "Set P-State voltages and clock speeds on recent AMD CPUs on Linux";
    mainProgram = "amdctl";
    homepage = "https://github.com/kevinlekiller/amdctl";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
