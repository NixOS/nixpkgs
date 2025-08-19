{
  lib,
  fetchFromGitHub,
  stdenv,
  gcc,
  python312Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "almo";
  version = "0.9.6-alpha";

  src = fetchFromGitHub {
    owner = "abap34";
    repo = "almo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eNigZUeUz6ZjQsn+0S6+Orv0WoLbqGgoA3+wG5ZcSBI=";
  };

  buildInputs = [
    gcc
    python312Packages.pybind11
  ];

  makeFlags = [ "all" ];

  # remove darwin-only linker flag on linux
  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace scripts/pybind.sh \
      --replace-fail " -undefined dynamic_lookup" ""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    cp build/almo $out/bin
    cp almo.so $out/lib
    runHook postInstall
  '';

  meta = {
    description = "Markdown parser and static site generator";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    homepage = "https://github.com/abap34/almo";
    changelog = "https://github.com/abap34/almo/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "almo";
  };
})
