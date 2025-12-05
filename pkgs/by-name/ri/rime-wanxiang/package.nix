{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-wanxiang";
  version = "13.4.11";

  src = fetchFromGitHub {
    owner = "amzxyz";
    repo = "rime_wanxiang";
    tag = "v" + finalAttrs.version;
    hash = "sha256-k5yJ7k33ttA8+ejMhxoJrhFQvRDtLmXqS9al2EQQOr0=";
  };

  installPhase = ''
    runHook preInstall

    rm -rf README.md .git* custom LICENSE

    mv default.yaml wanxiang_suggested_default.yaml

    mkdir -p $out/share
    cp -r . $out/share/rime-data

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-rich pinyin schema for Rime";
    longDescription = ''
      万象拼音 is a quanpin and shuangpin input schema for Rime based on
      [万象 dictionaries and grammar models](https://github.com/amzxyz/RIME-LMDG),
      supporting traditional shuangpin as well as tonal schemata such as 自然龙 and
      龙码.

      This package is built from the upstream repository snapshots, and includes
      all the auxiliary encodings.

      The schema requires to work the grammar model `wanxiang-lts-zh-hans.gram`.
      However, this file is
      [released](https://github.com/amzxyz/RIME-LMDG/releases/tag/LTS) by
      carelessly overriding the old versions
      (see the [discussion](https://github.com/amzxyz/RIME-LMDG/issues/22)). So
      we can't pack it into Nixpkgs, which demands reproducibility. You have to
      download it yourself and place it in the user directory of Rime.

      The upstream `default.yaml` is included as
      `wanxiang_suggested_default.yaml`. To enable it, please modify your
      `default.custom.yaml` as such:

      ```yaml
      patch:
        __include: wanxiang_suggested_default:/
      ```
    '';
    homepage = "https://github.com/amzxyz/rime_wanxiang";
    downloadPage = "https://github.com/amzxyz/rime_wanxiang/releases";
    changelog = "https://github.com/amzxyz/rime_wanxiang/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.all;
  };
})
