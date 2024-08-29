{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  pname = "swiftlint";
  version = "0.56.2";

  src = fetchurl (
    if stdenvNoCC.isDarwin then
      {
        url = "https://github.com/realm/SwiftLint/releases/download/${version}/portable_swiftlint.zip";
        hash = "sha256-vfwALzKDBN/tyhZWZs7Llf23yqt7R27FsPtV33884MI=";
      }
    else
      {
        url = "https://github.com/realm/SwiftLint/releases/download/${version}/swiftlint_linux.zip";
        hash = "sha256-KN9NqH4OC8nbLC53VXMNAnjsTXRKnld28q0RPCAfG2M=";
      }
  );

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
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
