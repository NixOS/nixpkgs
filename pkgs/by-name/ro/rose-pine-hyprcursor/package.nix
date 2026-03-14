{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rose-pine-hyprcursor";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ndom91";
    repo = "rose-pine-hyprcursor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ArUX5qlqAXUqcRqHz4QxXy3KgkfasTPA/Qwf6D2kV0U=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/rose-pine-hyprcursor
    cp -R . $out/share/icons/rose-pine-hyprcursor/

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Rose Pine theme for Hyprcursor";
    homepage = "https://github.com/ndom91/rose-pine-hyprcursor";
    changelog = "https://github.com/ndom91/rose-pine-hyprcursor/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      johnrtitor
    ];
  };
})
