{ lib
, stdenv
, fetchurl
, deno
, makeWrapper
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "silverbullet";
  version = "0.8.2";

  src = fetchurl {
    url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet.js";
    hash = "sha256-Y2WhxgiLJLMqwUK8KuNbuGbKfz5XOfD4Z1zxFqrAI1U=";
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
    description = "Open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aorith ];
    mainProgram = "silverbullet";
    inherit (deno.meta) platforms;
  };
})
