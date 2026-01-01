{
  lib,
  stdenv,
  fetchFromSourcehut,
  makeBinaryWrapper,
  openssl,
  libssh2,
  nim,
  pkg-config,
  brotli,
  gitUpdater,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chawan";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-JPFQsu5vLSesgpbX79Z5e0GGFIsC4PUJuZQS8a5Oq2c=";
=======
    hash = "sha256-y1z1MlwbKGpvtgt4OZtfvxvsOSE6RhnsWUeaRvu7etU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isClang "-Wno-error=implicit-function-declaration"
  );

  nativeBuildInputs = [
    makeBinaryWrapper
    nim
    pkg-config
    brotli
  ];

  buildInputs = [
    openssl
    libssh2
  ];

  buildFlags = [
    "all"
  ];
  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  postInstall =
    let
      makeWrapperArgs = ''
        --set MANCHA_CHA $out/bin/cha
      '';
    in
    ''
      wrapProgram $out/bin/mancha ${makeWrapperArgs}
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Lightweight and featureful terminal web browser";
    homepage = "https://sr.ht/~bptato/chawan/";
    changelog = "https://git.sr.ht/~bptato/chawan/refs/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "cha";
  };
})
