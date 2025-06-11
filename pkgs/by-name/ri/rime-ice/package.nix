{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2025.04.06";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    tag = finalAttrs.version;
    hash = "sha256-s3r8cdEliiPnKWs64Wgi0rC9Ngl1mkIrLnr2tIcyXWw=";
  };

  installPhase = ''
    runHook preInstall

    rm -rf others README.md .git*

    mv default.yaml rime_ice_suggestion.yaml

    mkdir -p $out/share
    cp -r . $out/share/rime-data

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Actively maintained simplified Chinese dictionary with full and double pinyin support";
    longDescription = ''
      Rime-Ice (雾凇拼音) provides a comprehensive, ready-to-use configuration.
      It includes full Pinyin and popular Double Pinyin layouts,
      a well-maintained open-source dictionary,
      and a wide range of extended features.

      To enable the upstream `default.yaml`
      (provided as `rime_ice_suggestion.yaml`),
      add the following to your `default.custom.yaml`:

      ```yaml
      patch:
        __include: rime_ice_suggestion:/
      ```
    '';
    homepage = "https://github.com/iDvel/rime-ice";
    changelog = "https://github.com/iDvel/rime-ice/blob/main/others/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      xddxdd
      moraxyc
      luochen1990
      wrvsrx
    ];
  };
})
