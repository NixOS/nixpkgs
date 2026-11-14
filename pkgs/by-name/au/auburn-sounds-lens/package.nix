{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  libX11,
  libgcc,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "auburn-sounds-lens";
  version = "1.3.1";

  src = fetchzip {
    url = "https://www.auburnsounds.com/downloads/Lens-FREE-${finalAttrs.version}.zip";
    hash = "sha256-Ozu+9wrDK2S0A2HrW1R/Zt6USGG9qXu0xSc/Xu8OnHs=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libX11
    libgcc
  ];

  installPhase =
    let
      mkInstaller = format: ''
        mkdir -p $out/lib/${format}
        cp -r "Linux-64b-${lib.toUpper format}-FREE/Auburn Sounds Lens.${format}" $out/lib/${format}
      '';
      mkInstallers = formats: lib.concatStringsSep "\n" (map mkInstaller formats);
    in
    ''
      runHook preInstall

      pushd Linux
        ${mkInstallers [
          "clap"
          "lv2"
          "vst3"
        ]}
      popd

      runHook postInstall
    '';

  meta = {
    description = "Spectral dynamics processor with unbelievable punch and clarity";
    homepage = "https://www.auburnsounds.com/products/Lens.html";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
