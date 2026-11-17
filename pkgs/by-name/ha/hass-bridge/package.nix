{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  networkmanager,
  python3,
  runCommand,
}:

let
  python = python3.withPackages (ps: [ ps.websockets ]);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hass-bridge";
  version = "0.5.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "konradk";
    repo = "hass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sQWBX4avXEfOc900AYPZyHH9xNvBA5iB8+J6zqajPE8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ python ];

  postPatch = ''
    rm -r vendor
  '';

  dontBuild = true;
  doCheck = true;

  checkPhase = ''
    runHook preCheck
    PYTHONNOUSERSITE=1 PYTHONDONTWRITEBYTECODE=1 python3 tests/test_bridge.py
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/hass-bridge "$out/libexec/hass-bridge"
    makeWrapper ${python}/bin/python3 "$out/bin/hass-bridge" \
      --add-flags "$out/libexec/hass-bridge" \
      --prefix PATH : ${lib.makeBinPath [ networkmanager ]}
    install -Dm644 README.md "$out/share/doc/hass-bridge/README.md"
    runHook postInstall
  '';

  passthru.tests.protocol = runCommand "hass-bridge-protocol" { nativeBuildInputs = [ python3 ]; } ''
    python3 ${./test.py} ${finalAttrs.finalPackage}/bin/hass-bridge
    touch "$out"
  '';

  meta = {
    description = "Home Assistant WebSocket bridge for the hass Quickshell plugin";
    homepage = "https://github.com/konradk/hass";
    changelog = "https://github.com/konradk/hass/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.JEFF7712 ];
    platforms = lib.platforms.linux;
    mainProgram = "hass-bridge";
  };
})
