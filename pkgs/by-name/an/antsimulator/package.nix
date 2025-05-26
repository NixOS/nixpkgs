{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml_2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "antsimulator";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "johnBuffer";
    repo = "AntSimulator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1KWoGbdjF8VI4th/ZjAzASgsLEuS3xiwObulzxQAppA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml_2 ];

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail "res/" "$out/opt/antsimulator/"

    substituteInPlace include/simulation/config.hpp \
      --replace-fail "res/" "$out/opt/antsimulator/"

    substituteInPlace include/render/colony_renderer.hpp \
      --replace-fail "res/" "$out/opt/antsimulator/"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/opt/antsimulator res/*
    install -Dm755 ./AntSimulator $out/bin/antsimulator

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/johnBuffer/AntSimulator";
    description = "Simple Ants simulator";
    mainProgram = "antsimulator";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
