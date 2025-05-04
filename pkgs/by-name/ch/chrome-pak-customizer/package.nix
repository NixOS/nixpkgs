{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  ninja,
}:

stdenv.mkDerivation {
  pname = "chrome-pak-customizer";
  version = "2.0-unstable-2021-06-24";

  src = fetchFromGitHub {
    owner = "myfreeer";
    repo = "chrome-pak-customizer";
    rev = "bfabc033207ebbd6e0017ce99500d3e379a0a3f6";
    hash = "sha256-MCGLbHSUPcO1nMUYCqRws4+hLGEaNjX9oqGzixw8VWY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    installShellFiles
  ];

  cmakeFlags = [ (lib.cmakeBool "LGPL" false) ];

  installPhase = ''
    runHook preInstall

    installBin pak

    runHook postInstall
  '';

  meta = {
    description = "Simple batch tool to customize pak files in chrome or chromium-based browser";
    homepage = "https://github.com/myfreeer/chrome-pak-customizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "pak";
    platforms = lib.platforms.all;
  };
}
