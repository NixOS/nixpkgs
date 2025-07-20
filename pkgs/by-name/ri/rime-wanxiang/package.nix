{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  librime,
  rime-data,
  nix-update-script,
  callPackage,
  useDataUpdater ? false,
}:

let
  dataUpdater = callPackage ./data-updater.nix { };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-wanxiang";
  version = "8.7.7";

  src = fetchFromGitHub {
    owner = "amzxyz";
    repo = "rime_wanxiang";
    tag = "v" + finalAttrs.version;
    hash = "sha256-X64kxr93V0ilAefmQcJgMCegdzpoNoI0TuMdkYRG66I=";
  };

  nativeBuildInputs = [
    librime
    rime-data
  ];

  buildInputs = lib.optional useDataUpdater dataUpdater;

  dontConfigure = true;

  postPatch = ''
    rm -r .github custom LICENSE squirrel.yaml weasel.yaml *.md *.trime.yaml
  '';

  buildPhase = ''
    runHook preBuild

    for s in *.schema.yaml; do
        rime_deployer --compile "$s" . ${rime-data}/share/rime-data ./build
    done

    rm build/*.txt

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dst=$out/share/rime-data
    mkdir -p $dst

    mv default.yaml wanxiang_suggested_default.yaml

    cp -pr -t $dst *

    runHook postInstall
  '';

  postInstall = lib.optionalString useDataUpdater ''
    bin=$out/bin
    mkdir -p $bin
    ln -s ${dataUpdater}/bin/* $bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-rich pinyin schema for Rime, basic edition";
    longDescription = ''
      万象拼音 is a full and double pinyin input schema for Rime based on
      [万象 dictionaries and grammar models](https://github.com/amzxyz/RIME-LMDG),
      supporting multiple input styles, tonal dictionaries and predictions.

      The upstream `default.yaml` is included as
      `wanxiang_suggested_default.yaml`.
      To enable it, please modify your `default.custom.yaml` as such:

      ```yaml
      patch:
        __include: wanxiang_suggested_default:/
      ```

      For further fine-grained tweaks, refer to it's
      [README](https://github.com/amzxyz/rime_wanxiang) page.

      Please note that, the schema requires the grammar model
      `wanxiang-lts-zh-hans.gram` to work. However, it is
      [released](https://github.com/amzxyz/RIME-LMDG/releases/tag/LTS) by
      carelessly overriding the old version of the file under the same tag
      (see the [discussion](https://github.com/amzxyz/RIME-LMDG/issues/22)).
      This is against reproducibility in Nix so we can't include it within this
      package. Same goes for dictionary releases.

      To make it easier updating grammar model and dictionaries, users can
      run the helper script `rime-wanxiang-data-updater` shipped with this
      package.  It is disabled by default.  Use override to enable it.

      ```nix
      pkgs.rime-wanxiang.override { useDataUpdater = true; }
      ```
    '';
    homepage = "https://github.com/amzxyz/rime_wanxiang";
    downloadPage = "https://github.com/amzxyz/rime_wanxiang/releases";
    changelog = "https://github.com/amzxyz/rime_wanxiang/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [
      rc-zb
      peromage
    ];
    platforms = lib.platforms.all;
  };
})
