{
  lib,
  stdenvNoCC,
  fetchzip,
  writeShellApplication,
  curl,
  gnugrep,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ipamjfont";
  version = "006.01";

  src =
    let
      suffix = lib.strings.replaceString "." "" finalAttrs.version;
    in
    fetchzip {
      url = "https://dforest.watch.impress.co.jp/library/i/ipamjfont/10750/ipamjm${suffix}.zip";
      hash = "sha256-Rft8hmxm3D4hOaLaSYDfD14oarDIHUQkMZX+/ZDD4m0=";
      stripRoot = false;
    };

  installPhase = ''
    runHook preInstall

    install -Dm444 *.ttf -t "$out/share/fonts/truetype/"

    runHook postInstall
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "${finalAttrs.pname}-updater";

      runtimeInputs = [
        curl
        gnugrep
        common-updater-scripts
      ];

      text = ''
        suffix="$(
          curl --fail --silent 'https://forest.watch.impress.co.jp/library/software/ipamjfont/download_10750.html' | \
            grep --perl-regexp --only-matching 'meta.+?ipamjm\K[0-9]+'
        )"
        version="''${suffix:0:3}.''${suffix:3:2}"
        update-source-version '${finalAttrs.pname}' "$version" --ignore-same-version --print-changes
      '';
    });
  };

  meta = {
    description = "Japanese Mincho font implementing IVS compliant with Hanyo-Denshi collection";
    downloadPage = "https://forest.watch.impress.co.jp/library/software/ipamjfont/";
    homepage = "https://moji.or.jp/mojikiban/font/";
    license = lib.licenses.ipa;
    maintainers = with lib.maintainers; [
      kachick
    ];
  };
})
