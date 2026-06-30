{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "migu";
  version = "20150712";

  srcs = [
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-1p-${finalAttrs.version}.zip";
      sha256 = "04wpbk5xbbcv2rzac8yzj4ww7sk2hy2rg8zs96yxc5vzj9q7svf6";
      name = "migu-1p-${finalAttrs.version}.zip";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-1c-${finalAttrs.version}.zip";
      sha256 = "1k7ymix14ac5fb44bjvbaaf24784zzpyc1jj2280c0zdnpxksyk6";
      name = "migu-1c-${finalAttrs.version}.zip";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-1m-${finalAttrs.version}.zip";
      sha256 = "07r8id83v92hym21vrqmfsfxb646v8258001pkjhgfnfg1yvw8lm";
      name = "migu-1m-${finalAttrs.version}.zip";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-2m-${finalAttrs.version}.zip";
      sha256 = "1pvzbrawh43589j8rfxk86y1acjbgzzdy5wllvdkpm1qnx28zwc2";
      name = "migu-2m-${finalAttrs.version}.zip";
    })
  ];
  sourceRoot = ".";
  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "High-quality Japanese font based on modified M+ fonts and IPA fonts";
    homepage = "http://mix-mplus-ipa.osdn.jp/migu/";
    license = lib.licenses.ipa;
    maintainers = [ lib.maintainers.mikoim ];
  };
})
