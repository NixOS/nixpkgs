{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  joker,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "goku";
  version = "0.8.0";

  src =
    if stdenvNoCC.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${finalAttrs.version}/goku-arm.zip";
        hash = "sha256-yRLxUfAQZ+rE7/42wnjls6UnT+vb/b5Y3lVWujZGEAg=";
      }
    else
      fetchurl {
        url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${finalAttrs.version}/goku.zip";
        hash = "sha256-hbk7QF0kTeBcot4OFV/yhVOUV/OpE44d/7nofdoBipg=";
      };

  nativeBuildInputs = [ unzip ];

  buildInputs = [ joker ];

  sourceRoot = if stdenvNoCC.hostPlatform.isAarch64 then "goku" else ".";

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    chmod +x {goku,gokuw}
    cp {goku,gokuw} "$out/bin"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/yqrashawn/GokuRakuJoudo/blob/v${finalAttrs.version}/CHANGELOG.org";
    description = "Karabiner configurator";
    homepage = "https://github.com/yqrashawn/GokuRakuJoudo";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nikitavoloboev ];
    platforms = lib.platforms.darwin;
  };
})
