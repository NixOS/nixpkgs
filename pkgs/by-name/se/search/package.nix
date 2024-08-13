{
  lib,
  odin,
  xorg,
  libGL,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "V1.0";
  pname   = "search";

  src = fetchFromGitHub {
    repo  = "Search";
    owner = "Vonixxx";
    rev   = finalAttrs.version;
    hash  = "sha256-VIxdF3+/3CjPw/L/e44oEDvZ8uPUpXcq8RPo4Eidn7M=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    odin
    libGL
    xorg.libX11
  ];

  postPatch = ''
     patchShebangs build.sh
  '';

  buildPhase = ''
     runHook preBuild

     ./build.sh

     runHook postBuild
  '';

  installPhase = ''
     runHook preInstall

     install -Dm755 search $out/bin/search
     wrapProgram $out/bin/search --set-default ODIN_ROOT ${odin}/share

     runHook postInstall
  '';

  meta = {
    inherit (odin.meta) platforms;
    description = "A Simple Search Utility";
    homepage = "https://github.com/Vonixxx/Search";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      vonixxx
    ];
    mainProgram = "search";
  };
})
