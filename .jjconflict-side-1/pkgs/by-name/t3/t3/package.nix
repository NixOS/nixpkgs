{
  fetchFromGitHub,
  help2man,
  lib,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "t3";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "flox";
    repo = "t3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-49nmFvyA5HtX0rTqG4vrCdQPo78HMF7wIN4StItShB4=";
    postFetch = "rm -f $out/.flox/env/manifest.lock";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${finalAttrs.version}"
  ];
  nativeBuildInputs = [ help2man ];
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next generation tee with colorized output streams and precise time stamping";
    homepage = "https://github.com/flox/t3";
    changelog = "https://github.com/flox/t3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ limeytexan ];
    platforms = lib.platforms.unix;
    mainProgram = "t3";
  };
})
