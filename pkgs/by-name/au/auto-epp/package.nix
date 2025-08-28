{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "auto-epp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jothi-prasath";
    repo = "auto-epp";
    tag = "v${version}";
    hash = "sha256-7sI8K+7ZAdzBN/XOzYQQZ1f9t+fFo6fcXYzX6abNyQ8=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall
    install -Dm555 auto-epp $out/bin/auto-epp
    runHook postInstall
  '';

  meta = with lib; {
    mainProgram = "auto-epp";
    homepage = "https://github.com/jothi-prasath/auto-epp";
    description = "Energy performance preference tuner for AMD processors when amd_pstate=active";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.lamarios ];
  };
}
