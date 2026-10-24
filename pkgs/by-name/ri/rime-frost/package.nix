{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-frost";
  version = "1.0.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gaboolic";
    repo = "rime-frost";
    tag = finalAttrs.version;
    hash = "sha256-1yxbLuVcCqgHGS14AecbVL7AQFGC/wbFO7US3Onz/R0=";
  };

  installPhase = ''
    runHook preInstall

    rm -rf others README.md .git*

    mv default.yaml rime_frost_suggestion.yaml

    mkdir -p $out/share
    cp -r . $out/share/rime-data

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { ignoredVersions = "nightly"; };

  meta = {
    description = "Simplified Chinese Rime schema with retrained word frequencies";
    longDescription = ''
      Rime-Frost (白霜拼音) is a simplified Chinese Rime schema based on
      rime-ice. Upstream rebuilt the dictionaries from a large high-quality
      corpus so word frequencies are cleaner than stock rime-ice.
      Full Pinyin and popular Double Pinyin layouts are included.

      To enable the upstream `default.yaml`
      (provided as `rime_frost_suggestion.yaml`),
      add the following to your `default.custom.yaml`:

      ```yaml
      patch:
        __include: rime_frost_suggestion:/
      ```
    '';
    homepage = "https://github.com/gaboolic/rime-frost";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hongjr03 ];
  };
})
