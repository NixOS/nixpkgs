{
  lib,
  stdenvNoCC,
  makeWrapper,
  nodejs,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hamr";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "p2r3";
    repo = "ha.mr";
    tag = "v${finalAttrs.version}";
    hash = "";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    cp alphabets.js compress.js standalone.js $out/lib
    makeWrapper ${lib.getExe nodejs} $out/bin/hamr \
      --add-flags "$out/lib/standalone.js"
    runHook postInstall
  '';

  meta = {
    description = "Static URL compressor and QR code optimizer";
    homepage = "https://github.com/p2r3/ha.mr";
    mainProgram = "hamr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.libewa ];
  };
  strictDeps = true;
  __structuredAttrs = true;
})
