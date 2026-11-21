{
  fetchurl,
  appimageTools,
  lndir,
  pname,
  version,
  sha256,
  metaCommon ? { },
}:

appimageTools.wrapType2 (finalAttrs: {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/sindresorhus/caprine/releases/download/v${version}/Caprine-${version}.AppImage";
    name = "Caprine-${version}.AppImage";
    inherit sha256;
  };

  passthru = {
    inherit (finalAttrs) src;
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraInstallCommands = ''
    mkdir -p $out/share
    "${lndir}/bin/lndir" -silent "${finalAttrs.contents}/usr/share" "$out/share"
    ln -s ${finalAttrs.contents}/caprine.png $out/share/icons/caprine.png
    mkdir $out/share/applications
    cp ${finalAttrs.contents}/caprine.desktop $out/share/applications/
    substituteInPlace $out/share/applications/caprine.desktop \
        --replace AppRun caprine
  '';

  meta = metaCommon // {
    platforms = [ "x86_64-linux" ];
  };
})
