{
  lib,
  stdenv,
  fetchFromGitHub,
  deno,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "era";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "era";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OOPVLY9kg4TmKSrpHgsOmAmeDPbX5df0bX51lA6DvcY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp -r $src/{src,LICENSE,README.md} $out/lib
    makeWrapper ${lib.getExe deno} $out/bin/era \
      --set DENO_NO_UPDATE_CHECK "1" \
      --add-flags "run -A $out/lib/src/main.ts"

    runHook postInstall
  '';

  meta = {
    description = "Rainy clock in your terminal";
    homepage = "https://github.com/kyoheiu/era";
    changelog = "https://github.com/kyoheiu/era/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "era";
    inherit (deno.meta) platforms;
  };
})
