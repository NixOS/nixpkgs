{
  lib,
  fetchFromGitHub,
  gitUpdater,
  nodePackages,
  stdenvNoCC,
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

  nativeBuildInputs = [ nodePackages.browserify ];

  buildPhase = ''
    runHook preBuild

    make dist/${finalAttrs.passthru.scriptName}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D dist/${finalAttrs.passthru.scriptName} $out/share/mpv/scripts/${finalAttrs.passthru.scriptName}

    runHook postInstall
  '';

  passthru.scriptName = "cheatsheet.js";

  meta = with lib; {
    description = "mpv script for looking up keyboard shortcuts";
    homepage = "https://github.com/ento/mpv-cheatsheet";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
})
