{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  writeShellScript,
  jq,
  curl,
  testers,
}:

let
  versions = lib.importJSON ./versions.json;
  arch = stdenv.hostPlatform.parsed.cpu.name;
  # proton use macos designation instead of darwin
  os = if stdenv.hostPlatform.isDarwin then "macos" else stdenv.hostPlatform.parsed.kernel.name;

  supportedCombinations = versions.passCliVersions.urls or { };
  isSupported = supportedCombinations ? ${os} && supportedCombinations.${os} ? ${arch};
  versionInfo =
    if isSupported then
      versions.passCliVersions.urls.${os}.${arch}
    else
      throw "Unsupported platform: ${os}-${arch}";

  inherit (versionInfo) url hash;
  inherit (versions.passCliVersions) version;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "proton-pass-cli";
  inherit version;

  # run ./update
  src = fetchurl {
    inherit url;
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/pass-cli
    wrapProgram $out/bin/pass-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          curl
        ]
      }

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "pass-cli --version";
    };
    updateScript = writeShellScript "update-version" ''
      set -euo pipefail
      ${lib.getExe curl} -fsSL -o pkgs/by-name/pr/proton-pass-cli/versions.json \
        https://proton.me/download/pass-cli/versions.json
    '';
  };

  meta = {
    description = "Command-line interface for Proton Pass";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.kirksw ];
    mainProgram = "pass-cli";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
