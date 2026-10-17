{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk,

  enableExperimentalFocusFirst ? false,
  enableOldActivationMethod ? false,
  enableAlternativeTaskSwitcher ? false,
}:
stdenv.mkDerivation rec {
  pname = "autoraise";
  version = "5.3";

  src = fetchFromGitHub {
    owner = "sbmpost";
    repo = "AutoRaise";
    rev = "v${version}";
    hash = "sha256-OsvmNHpQ46+cWkR4Nz/9oIgSFSWLfCwZnAnRKRiNm5E=";
  };

  buildInputs = [
    apple-sdk.privateFrameworksHook
  ];

  buildPhase = ''
    runHook preBuild
    $CXX -std=c++03 -fobjc-arc -D"NS_FORMAT_ARGUMENT(A)=" -D"SKYLIGHT_AVAILABLE=1" \
      ${lib.optionalString enableExperimentalFocusFirst "-DEXPERIMENTAL_FOCUS_FIRST"} \
      ${lib.optionalString enableOldActivationMethod "-DOLD_ACTIVATION_METHOD"} \
      ${lib.optionalString enableAlternativeTaskSwitcher "-DALTERNATIVE_TASK_SWITCHER"} \
      -o AutoRaise AutoRaise.mm -framework AppKit -framework SkyLight
    bash create-app-bundle.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin
    mv AutoRaise.app $out/Applications/AutoRaise.app
    ln -s $out/Applications/AutoRaise.app/Contents/MacOS/AutoRaise $out/bin/autoraise
    runHook postInstall
  '';

  meta = {
    description = "Automatically raise and focus a window when hovering over it with the mouse";
    homepage = "https://github.com/sbmpost/AutoRaise";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nickhu ];
    mainProgram = "autoraise";
    platforms = lib.platforms.darwin;
  };
}
