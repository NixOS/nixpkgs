{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  texinfo,
  makeWrapper,
  guile,
  guile-config,
  guile-lib,
  guix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-hall";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "a-sassmannshausen";
    repo = "guile-hall";
    rev = finalAttrs.version;
    hash = "sha256-pDQlG3C6bCz4jowR4Y99p/CGSqLlw04MTiWS32h9Z4c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    guix
    pkg-config
    texinfo
    makeWrapper
  ];

  buildInputs = [
    guile
    guile-config
    guile-lib
  ];

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/hall \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$TMPDIR
    $out/bin/hall --version | grep ${finalAttrs.version} > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Project manager and build tool for GNU guile";
    mainProgram = "hall";
    homepage = "https://gitlab.com/a-sassmannshausen/guile-hall";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = guile.meta.platforms;
  };
})
