{
  lib,
  fetchFromGitHub,
  gitUpdater,
  stdenvNoCC,
  webpack-cli,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mpv-cheatsheet";
  version = "0.30.0.2";

  src = fetchFromGitHub {
    owner = "ento";
    repo = "mpv-cheatsheet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MWK0CYto3zgn3fivmL43tvgZn6XrjPxKLp0lgTFdplM=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  nativeBuildInputs = [ webpack-cli ];

  buildPhase = ''
    runHook preBuild

    # Generate readable output, similar to upstream's use of `browserify`
    webpack --devtool source-map --mode development

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D dist/main.js $out/share/mpv/scripts/${finalAttrs.passthru.scriptName}

    runHook postInstall
  '';

  passthru.scriptName = "cheatsheet.js";

  meta = {
    description = "mpv script for looking up keyboard shortcuts";
    homepage = "https://github.com/ento/mpv-cheatsheet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
