{
  lib,
  stdenvNoCC,

  x2t,
  extra-fonts ? [ ],
}:

# https://github.com/ONLYOFFICE/document-server-package/blob/master/common/documentserver/bin/documentserver-generate-allfonts.sh.m4
stdenvNoCC.mkDerivation {
  name = "x2t-with-fonts-and-themes";
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  nativeBuildInputs = [
    x2t
    x2t.components.allfontsgen
    x2t.components.allthemesgen
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{web,converter,images,fonts}

    echo "Generating fonts"
    export CUSTOM_FONTS_PATHS=${lib.concatStringsSep ":" extra-fonts}
    ${lib.getExe' x2t.components.allfontsgen "allfontsgen"} \
      --input=${x2t.components.core-fonts} \
      --allfonts-web=$out/web/AllFonts.js \
      --allfonts=$out/converter/AllFonts.js \
      --images=$out/images \
      --selection=$out/converter/font_selection.bin \
      --output-web=$out/fonts \
      --use-system=true

    mkdir -p $out/bin
    # x2t hard-codes looking for DoctRenderer.config next to the binary,
    # so it has to live in $out/bin.
    # Use cp instead of ln -s: the codebase uses calls that don't follow symlinks.
    # Upstream issue: https://github.com/Euro-Office/server/pull/17
    cp ${lib.getExe x2t} $out/bin
    cat >$out/bin/DoctRenderer.config <<EOF
      <Settings>
        <file>${x2t.components.sdkjs}/common/Native/native.js</file>
        <file>${x2t.components.sdkjs}/common/Native/jquery_native.js</file>
        <allfonts>$out/converter/AllFonts.js</allfonts>
        <file>${x2t.components.web-apps}/vendor/xregexp/xregexp-all-min.js</file>
        <sdkjs>${x2t.components.sdkjs}</sdkjs>
        <dictionaries>${x2t.components.dictionaries}</dictionaries>
      </Settings>
    EOF

    echo "Generating presentation themes"
    # allthemesgen creates temporary files next to sources,
    # so copy themes to a working dir to avoid polluting the store.
    # Use cp instead of ln -s: the codebase uses calls that don't follow symlinks.
    mkdir working
    cp ${x2t.components.sdkjs}/slide/themes/src/* working
    ${lib.getExe' x2t.components.allthemesgen "allthemesgen"} \
      --converter-dir="$out/bin" \
      --src="working" \
      --output="$out/images"
    ${lib.getExe' x2t.components.allthemesgen "allthemesgen"} \
      --converter-dir="$out/bin" \
      --src="working" \
      --output="$out/images" \
      --postfix="ios" \
      --params="280,224"
    ${lib.getExe' x2t.components.allthemesgen "allthemesgen"} \
      --converter-dir="$out/bin" \
      --src="working" \
      --output="$out/images" \
      --postfix="android" \
      --params="280,224"

    runHook postInstall
  '';

  meta.mainProgram = "x2t";
}
