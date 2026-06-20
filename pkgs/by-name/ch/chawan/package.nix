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
  version = "0.3.3";

  src = fetchFromSourcehut {
    owner = "~bptato";
    repo = "chawan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GVDh94pgdMlwHMyqtT8q2yM+rwioodBYQfA+AOZ/CsU=";
  };

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
