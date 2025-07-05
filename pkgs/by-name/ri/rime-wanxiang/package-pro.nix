{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  librime,
  rime-data,
  nix-update-script,
  callPackage,
}:

let
  updater = callPackage ./dict-updater.nix { isProVersion = true; };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-wanxiang-pro";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "amzxyz";
    repo = "rime_wanxiang_pro";
    tag = "v" + finalAttrs.version;
    hash = "sha256-CpTMSK/ra2gluWuYKk33+YiNmJBsp3IBeA6VJgCEXMA=";
  };

  nativeBuildInputs = [
    librime
    rime-data
  ];

  buildInputs = [
    updater
  ];

  dontConfigure = true;

  patchPhase = ''
    runHook prePatch

    rm -r .github custom LICENSE squirrel.yaml weasel.yaml *.md *.trime.yaml

    runHook postPatch
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

    data_dir=$out/share/rime-data
    bin_dir=$out/bin
    mkdir -p $data_dir $bin_dir

    mv default.yaml wanxiang_pro_suggested_default.yaml

    cp -pr -t $data_dir *
    ln -s ${updater}/bin/* $bin_dir

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-rich pinyin schema for Rime, enhanced edition for double pinyin";
    longDescription = ''
      万象拼音双拼辅助码增强版 is an enhanced double pinyin input schema for
      Rime based on
      [万象 dictionaries and grammar models](https://github.com/amzxyz/RIME-LMDG),
      supporting multiple input styles, tonal dictionaries and predictions.

      The upstream `default.yaml` is included as
      `wanxiang_pro_suggested_default.yaml`.
      To enable it, please modify your `default.custom.yaml` as such:

      ```yaml
      patch:
        __include: wanxiang_pro_suggested_default:/
      ```

      For further fine-grained tweaks, refer to it's
      [README page](https://github.com/amzxyz/rime_wanxiang_pro).

      Please note that, the schema requires the grammar model
      `wanxiang-lts-zh-hans.gram` to work. However, it is
      [released](https://github.com/amzxyz/RIME-LMDG/releases/tag/LTS) by
      carelessly overriding the old version of the file under the same tag
      (see the [discussion](https://github.com/amzxyz/RIME-LMDG/issues/22)).
      This is against the reproducibility philosophy of Nix so we can't include
      it within this package. Same goes for dictionary releases.

      To make it easier updating grammar model and dictionaries, users can
      run the helper script `update-rime-wanxiang-pro-dict` shipped with this
      package.
    '';
    homepage = "https://github.com/amzxyz/rime_wanxiang_pro";
    downloadPage = "https://github.com/amzxyz/rime_wanxiang_pro/releases";
    changelog = "https://github.com/amzxyz/rime_wanxiang_pro/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ peromage ];
    platforms = lib.platforms.all;
  };
})
