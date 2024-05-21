{ lib
, stdenv
, fetchurl
, deno
, makeWrapper
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "silverbullet";
  version = "0.7.7";

  src = fetchurl {
    url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet.js";
    hash = "sha256-EhHPysliRi1bv/skS4+ljQW6qFsijmSup1+7/fVfFdg=";
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

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/website/CHANGELOG.md";
    description = "An open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aorith ];
    mainProgram = "silverbullet";
    inherit (deno.meta) platforms;
  };
})
