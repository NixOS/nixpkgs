{
  lib,
  stdenv,
  fetchurl,
  deno,
  makeWrapper,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "silverbullet";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet.js";
    hash = "sha256-O0QuzbY/ZdhOZvsUcgpZ55E+CSxbAsRxJmBQird5vCk=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib}
    cp $src $out/lib/silverbullet.js
    makeWrapper ${lib.getExe deno} $out/bin/silverbullet \
        --set DENO_NO_UPDATE_CHECK "1" \
        --add-flags "run -A --unstable-kv --unstable-worker-options ${placeholder "out"}/lib/silverbullet.js"
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) silverbullet;
  };

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/website/CHANGELOG.md";
    description = "Open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aorith ];
    mainProgram = "silverbullet";
    inherit (deno.meta) platforms;
  };
})
