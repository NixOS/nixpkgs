{
  lib,
  dtools,
  libclang,
  buildDubPackage,
  fetchFromGitHub,
}:

buildDubPackage (finalAttrs: {
  pname = "dpp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "atilaneves";
    repo = "dpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8zcjZ8EV5jdZrRCHkzxu9NeehY2/5AfOSdzreFC9z3c=";
  };

  nativeBuildInputs = [ dtools ];
  buildInputs = [ libclang ];

  dubLock = ./dub-lock.json;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/d++ -t $out/d++
    runHook postInstall
  '';

  meta = {
    description = "Directly include C headers in D source code";
    changelog = "https://github.com/atilaneves/dpp/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/atilaneves/dpp";
    mainProgram = "d++";
    maintainers = with lib.maintainers; [ ipsavitsky ];
    license = lib.licenses.boost;
  };
})
