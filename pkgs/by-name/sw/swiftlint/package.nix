{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  pname = "swiftlint";
  version = "0.55.1";

  src = fetchurl {
    url = "https://github.com/realm/SwiftLint/releases/download/${version}/portable_swiftlint.zip";
    hash = "sha256-Tmhw30CJaVQlcYnHjzmwrDpugHgR2/ihHIV8M+O2zwI=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 swiftlint $out/bin/swiftlint
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A tool to enforce Swift style and conventions";
    homepage = "https://realm.github.io/SwiftLint/";
    license = licenses.mit;
    mainProgram = "swiftlint";
    maintainers = with maintainers; [ matteopacini ];
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
