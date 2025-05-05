{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  boost,
  icu,
  qt5,
  harfbuzz,
  # needs to be static and built with MD2 support!
  openssl,
  runCommand,
  nodejs,
  onlyoffice-documentserver,
  writeScript,
  x2t,
}:

let
  qmake = qt5.qmake;
  libv8 = nodejs.libv8;
  fixIcu = writeScript "fix-icu.sh" ''
    substituteInPlace \
      $BUILDRT/Common/3dParty/icu/icu.pri \
      --replace-fail "ICU_MAJOR_VER = 58" "ICU_MAJOR_VER = ${lib.versions.major icu.version}"

    mkdir $BUILDRT/Common/3dParty/icu/linux_64
    ln -s ${icu}/lib $BUILDRT/Common/3dParty/icu/linux_64/build
  '';
  # see core/Common/3dParty/html/fetch.sh
  katana-parser-src = fetchFromGitHub {
    owner = "jasenhuang";
    repo = "katana-parser";
    rev = "be6df458d4540eee375c513958dcb862a391cdd1";
    hash = "sha256-SYJFLtrg8raGyr3zQIEzZDjHDmMmt+K0po3viipZW5c=";
  };
  # 'latest' version
  # (see build_tools scripts/core_common/modules/hyphen.py)
  hyphen-src = fetchFromGitHub {
    owner = "hunspell";
    repo = "hyphen";
    rev = "73dd2967c8e1e4f6d7334ee9e539a323d6e66cbd";
    hash = "sha256-WIHpSkOwHkhMvEKxOlgf6gsPs9T3xkzguD8ONXARf1U=";
  };
  # see core/Common/3dParty/html/fetch.py
  gumbo-parser-src = fetchFromGitHub {
    owner = "google";
    repo = "gumbo-parser";
    rev = "aa91b27b02c0c80c482e24348a457ed7c3c088e0";
    hash = "sha256-+607iXJxeWKoCwb490pp3mqRZ1fWzxec0tJOEFeHoCs=";
  };
  # core/Common/3dParty/apple/fetch.py
  libodfgen-src = fetchFromGitHub {
    owner = "DistroTech";
    repo = "libodfgen";
    rev = "8ef8c171ebe3c5daebdce80ee422cf7bb96aa3bc";
    hash = "sha256-Bv/smZFmZn4PEAcOlXD2Z4k96CK7A7YGDHFDsqZpuiE=";
  };
  mdds-src = fetchFromGitHub {
    owner = "kohei-us";
    repo = "mdds";
    rev = "0783158939c6ce4b0b1b89e345ab983ccb0f0ad0";
    hash = "sha256-HMGMxMRO6SadisUjZ0ZNBGQqksNDFkEh3yaQGet9rc0=";
  };
  glm-src = fetchFromGitHub {
    owner = "g-truc";
    repo = "glm";
    rev = "33b4a621a697a305bc3a7610d290677b96beb181";
    hash = "sha256-wwGI17vlQzL/x1O0ANr5+KgU1ETnATpLw3njpKfjnKQ=";
  };
  librevenge-src = fetchFromGitHub {
    owner = "DistroTech";
    repo = "librevenge";
    rev = "becd044b519ab83893ad6398e3cbb499a7f0aaf4";
    hash = "sha256-2YRxuMYzKvvQHiwXH08VX6GRkdXnY7q05SL05Vbn0Vs=";
  };
  libetonyek-src = fetchFromGitHub {
    owner = "LibreOffice";
    repo = "libetonyek";
    rev = "cb396b4a9453a457469b62a740d8fb933c9442c3";
    hash = "sha256-nFYI7PbcLyquhAWVGkjNLHp+tymv+Pzvfa5DNPeqZiw=";
  };
  #qmakeFlags = [ "CONFIG+=debug" ];
  qmakeFlags = [ ];
  dontStrip = false;
  core = fetchFromGitHub {
    owner = "ONLYOFFICE";
    repo = "core";
    # rev that the 'core' submodule in documentserver points at
    rev = "d257c68d5fdd71a33776a291914f2c856426c259";
    hash = "sha256-EXeqG8MJWS1asjFihnuMnDSHeKt2x+Ui+8MYK50AnSY=";
  };
  buildCoreComponent =
    rootdir: attrs:
    stdenv.mkDerivation (
      finalAttrs:
      {
        name = "onlyoffice-core-${rootdir}";
        src = core;
        sourceRoot = "${finalAttrs.src.name}/${rootdir}";
        dontWrapQtApps = true;
        nativeBuildInputs = [
          qmake
        ];
        inherit dontStrip qmakeFlags;
        prePatch = ''
          export SRCRT=$(pwd)
          cd $(echo "${rootdir}" | sed -s "s/[^/]*/../g")
          export BUILDRT=$(pwd)
          ln -s ../source ../core
          chmod -R u+w .
        '';
        postPatch = ''
          cd $SRCRT
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib
          # debug builds are a level deeper than release builds
          find $BUILDRT/build -type f -exec cp {} $out/lib \;

          runHook postInstall
        '';
      }
      // attrs
    );
  buildCoreTests =
    rootdir: attrs:
    (buildCoreComponent (rootdir + "/test") (
      {
        doCheck = true;
        checkPhase = ''
          runHook preCheck
          ./build/linux_64/test
          runHook postCheck
        '';
        installPhase = ''
          touch $out
        '';
      }
      // attrs
    ));
  unicodeConverter = buildCoreComponent "UnicodeConverter" {
    patches = [
      # icu needs c++20 for include/unicode/localpointer.h
      ./common-cpp20.patch
    ];
    preConfigure = ''
      source ${fixIcu}

      # https://github.com/ONLYOFFICE/core/pull/1637
      # (but not as patch because line endings)
      substituteInPlace \
        UnicodeConverter.cpp \
        --replace-fail "TRUE" "true"
    '';
  };
  kernel = buildCoreComponent "Common" {
    patches = [
      ./zlib-cstd.patch
    ];
    buildInputs = [
      unicodeConverter
    ];
  };
  unicodeConverterTests = buildCoreComponent "UnicodeConverter/test" {
    buildInputs = [
      unicodeConverter
      kernel
      icu
    ];
    preConfigure = ''
      source ${fixIcu}

      # adds includes but not build the lib?
      echo -e "\ninclude(../../Common/3dParty/icu/icu.pri)" >> test.pro
    '';
    postBuild = ''
      patchelf --add-rpath ${icu}/lib $(find ./core_build -name test)
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp $(find ./core_build -name test) $out/bin
      cp -r testfiles $out
      # TODO: this produces files in $out/testfiles. It looks like this should
      # test that the files are identical, which they are not - but it is not
      # obvious the test is 'wrong' :/
      $out/bin/test
    '';
  };
  graphics = buildCoreComponent "DesktopEditor/graphics/pro" {
    patches = [
      ./cximage-types.patch
    ];
    buildInputs = [
      unicodeConverter
      kernel
    ];
    preConfigure = ''
      ln -s ${katana-parser-src} $BUILDRT/Common/3dParty/html/katana-parser

      # Common/3dParty/harfbuzz/make.py
      cat >$BUILDRT/Common/3dParty/harfbuzz/harfbuzz.pri <<EOL
        INCLUDEPATH += ${harfbuzz.dev}/include/harfbuzz
        LIBS += -L${harfbuzz}/lib -lharfbuzz
      EOL

      ln -s ${hyphen-src} $BUILDRT/Common/3dParty/hyphen/hyphen
    '';
  };
  network = buildCoreComponent "Common/Network" {
    buildInputs = [
      kernel
    ];
  };
  docxformatlib = buildCoreComponent "OOXML/Projects/Linux/DocxFormatLib" {
    patches = [
      # Interestingly only seems to pop up when debug mode is enabled
      ./xlsx-missing-import.patch
    ];
    buildInputs = [ boost ];
  };
  cryptopp = buildCoreComponent "Common/3dParty/cryptopp/project" {
    buildInputs = [ boost ];
  };
  xlsbformatlib = buildCoreComponent "OOXML/Projects/Linux/XlsbFormatLib" {
    buildInputs = [ boost ];
  };
  xlsformatlib = buildCoreComponent "MsBinaryFile/Projects/XlsFormatLib/Linux" {
    patches = [
      ./MsBinaryFile-pragma-regions.patch
    ];
    buildInputs = [ boost ];
  };
  docformatlib = buildCoreComponent "MsBinaryFile/Projects/DocFormatLib/Linux" {
    buildInputs = [ boost ];
  };
  pptformatlib = buildCoreComponent "MsBinaryFile/Projects/PPTFormatLib/Linux" {
    buildInputs = [ boost ];
  };
  rtfformatlib = buildCoreComponent "RtfFile/Projects/Linux" {
    buildInputs = [ boost ];
  };
  txtxmlformatlib = buildCoreComponent "TxtFile/Projects/Linux" {
    buildInputs = [ boost ];
  };
  bindocument = buildCoreComponent "OOXML/Projects/Linux/BinDocument" {
    buildInputs = [ boost ];
  };
  pptxformatlib = buildCoreComponent "OOXML/Projects/Linux/PPTXFormatLib" {
    buildInputs = [ boost ];
  };
  compoundfilelib = buildCoreComponent "Common/cfcpp" { };
  iworkfile = buildCoreComponent "Apple" {
    patches = [
      ./zlib-cstd.patch
    ];
    # mdds uses bool_constant which needs a newer c++
    qmakeFlags = qmakeFlags ++ [ "CONFIG+=c++1z" ];
    buildInputs = [
      kernel
      unicodeConverter
      boost
    ];
    preConfigure = ''
      ln -s ${glm-src} $BUILDRT/Common/3dParty/apple/glm
      ln -s ${mdds-src} $BUILDRT/Common/3dParty/apple/mdds
      ln -s ${libodfgen-src} $BUILDRT/Common/3dParty/apple/libodfgen
      ln -s ${librevenge-src} $BUILDRT/Common/3dParty/apple/librevenge
      cp -r ${libetonyek-src} $BUILDRT/Common/3dParty/apple/libetonyek
      substituteInPlace \
        $BUILDRT/Common/3dParty/apple/libetonyek/src/lib/IWORKTable.cpp \
        --replace-fail "is_tree_valid" "valid_tree"
      chmod u+w $BUILDRT/Common/3dParty/apple/libetonyek/src/lib
      cp $BUILDRT/Common/3dParty/apple/headers/* $BUILDRT/Common/3dParty/apple/libetonyek/src/lib
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      mv ../build/lib/*/* $out/lib
      runHook postInstall
    '';
    doCheck = true;
  };
  vbaformatlib = buildCoreComponent "MsBinaryFile/Projects/VbaFormatLib/Linux" {
    buildInputs = [ boost ];
  };
  odfformatlib = buildCoreComponent "OdfFile/Projects/Linux" {
    buildInputs = [ boost ];
  };
  hwpfile = buildCoreComponent "HwpFile" {
    buildInputs = [
      cryptopp
      kernel
      unicodeConverter
      graphics
    ];
  };
  pdffile = buildCoreComponent "PdfFile" {
    buildInputs = [
      graphics
      kernel
      unicodeConverter
      cryptopp
      network
    ];
  };
  djvufile = buildCoreComponent "DjVuFile" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
      pdffile
    ];
  };
  docxrenderer = buildCoreComponent "DocxRenderer" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
    ];
  };
  xpsfile = buildCoreComponent "XpsFile" {
    buildInputs = [
      unicodeConverter
      graphics
      kernel
      pdffile
    ];
  };
  doctrenderer = buildCoreComponent "DesktopEditor/doctrenderer" {
    buildInputs = [
      graphics
      boost
      kernel
      unicodeConverter
      network
      pdffile
      djvufile
      xpsfile
      docxrenderer
    ];
    patches = [
      # https://github.com/ONLYOFFICE/core/pull/1631
      ./doctrenderer-format-security.patch
      ./doctrenderer-config-dir.patch
      ./fontengine-format-security.patch
      ./v8_updates.patch
      ./common-v8-no-compress-pointers.patch
      # we can enable snapshots again once we
      # compile sdkjs from source as well
      ./common-v8-no-snapshots.patch
      # needed for c++ 20 for nodejs_23
      ./common-pole-c20.patch
    ];
    qmakeFlags = qmakeFlags ++ [
      # c++1z for nodejs_22.libv8 (20 seems to produce errors around 'is_void_v' there)
      # c++ 20 for nodejs_23.libv8
      "CONFIG+=c++2a"
      # v8_base.h will set nMaxVirtualMemory to 4000000000/5000000000
      # which is not page-aligned, so disable memory limitation for now
      "QMAKE_CXXFLAGS+=-DV8_VERSION_121_PLUS"
      "QMAKE_CXXFLAGS+=-DDISABLE_MEMORY_LIMITATION"
    ];
    preConfigure = ''
      cd $BUILDRT

      substituteInPlace \
        DesktopEditor/doctrenderer/nativecontrol.h \
        --replace-fail "fprintf(f, strVal.c_str());" "fprintf(f, \"%s\", strVal.c_str());" \
        --replace-fail "fprintf(_file, sParam.c_str());" "fprintf(_file, \"%s\", sParam.c_str());"

      # (not as patch because of line endings)
      sed -i '47 a #include <limits>' Common/OfficeFileFormatChecker2.cpp

      echo "== openssl =="
      mkdir -p Common/3dParty/openssl/build/linux_64/lib
      echo "Including openssl from ${openssl.dev}"
      ln -s ${openssl.dev}/include Common/3dParty/openssl/build/linux_64/include
      for i in ${openssl.out}/lib/*; do
        ln -s $i Common/3dParty/openssl/build/linux_64/lib/$(basename $i)
      done

      echo "== v8 =="
      mkdir -p Common/3dParty/v8_89/v8/out.gn/linux_64
      ln -s ${libv8}/lib Common/3dParty/v8_89/v8/out.gn/linux_64/obj
      tar xf ${libv8.src} --one-top-level=/tmp/xxxxx
      for i in /tmp/xxxxx/*/deps/v8/*; do
        cp -r $i Common/3dParty/v8_89/v8/
      done

      cd $BUILDRT/DesktopEditor/doctrenderer
    '';
  };
  htmlfile2 = buildCoreComponent "HtmlFile2" {
    buildInputs = [
      boost
      kernel
      network
      graphics
      unicodeConverter
    ];
    preConfigure = ''
      ln -s ${katana-parser-src} $BUILDRT/Common/3dParty/html/katana-parser
      ln -s ${gumbo-parser-src} $BUILDRT/Common/3dParty/html/gumbo-parser
    '';
  };
  epubfile = buildCoreComponent "EpubFile" {
    buildInputs = [
      kernel
      graphics
      htmlfile2
    ];
  };
  fb2file = buildCoreComponent "Fb2File" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
      boost
    ];
    preConfigure = ''
      ln -s ${gumbo-parser-src} $BUILDRT/Common/3dParty/html/gumbo-parser
    '';
    passthru.tests.run = buildCoreTests "Fb2File" {
      buildInputs = [
        fb2file
        kernel
      ];
      preConfigure = ''
        source ${fixIcu}
      '';
      postBuild = ''
        patchelf --add-rpath ${icu}/lib build/*/*
      '';
      checkPhase = ''
        for i in ../examples/*.fb2; do
          cp $i build/linux_64/res.fb2
          ./build/linux_64/test
        done
      '';
    };
  };
  allfontsgen = buildCoreComponent "DesktopEditor/AllFontsGen" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
    ];
    preConfigure = ''
      source ${fixIcu}
    '';
    dontStrip = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $BUILDRT/build/bin/*/* $BUILDRT/build/bin/*/*/* $out/bin

      patchelf --add-rpath ${icu}/lib $out/bin/allfontsgen

      runHook postInstall
    '';
  };
  core-fonts = fetchFromGitHub {
    owner = "ONLYOFFICE";
    repo = "core-fonts";
    rev = "d5d80e6ae15800ccf31e1c4dbb1ae3385992e0c2";
    hash = "sha256-daJG/4tcdRVVmlMCUW4iuoUkEEfY7sx5icYWMva4o+c=";
  };
  allfonts = runCommand "allfonts" { } ''
    mkdir -p $out/web
    mkdir -p $out/converter
    mkdir -p $out/images
    mkdir -p $out/fonts
    ${allfontsgen}/bin/allfontsgen \
      --input=${core-fonts} \
      --allfonts-web=$out/web/AllFonts.js \
      --allfonts=$out/converter/AllFonts.js \
      --images=$out/images \
      --selection=$out/converter/font_selection.bin \
      --output-web=$out/fonts
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "x2t";
  # x2t is not 'directly' versioned, so we version it after the version
  # of documentserver it's pulled into as a submodule
  version = "8.3.2";

  src = core;

  nativeBuildInputs = [
    pkg-config
    qt5.full
  ];
  buildInputs = [
    unicodeConverter
    kernel
    graphics
    network
    boost
    docformatlib
    pptformatlib
    rtfformatlib
    txtxmlformatlib
    bindocument
    pptxformatlib
    docxformatlib
    xlsbformatlib
    xlsformatlib
    compoundfilelib
    cryptopp
    fb2file
    pdffile
    htmlfile2
    epubfile
    xpsfile
    djvufile
    doctrenderer
    docxrenderer
    iworkfile
    hwpfile
    vbaformatlib
    odfformatlib
  ];
  dontStrip = true;
  buildPhase = ''
    runHook preBuild

    BUILDRT=$(pwd)
    source ${fixIcu}

    # (not as patch because of line endings)
    sed -i '47 a #include <limits>' Common/OfficeFileFormatChecker2.cpp

    substituteInPlace \
      ./Test/Applications/TestDownloader/mainwindow.h \
      --replace-fail "../core" ""

    echo "== X2tConverter =="
    cd X2tConverter/build/Qt
    qmake "CONFIG+=debug" -o Makefile X2tConverter.pro
    make -j$NIX_BUILD_CORES
    cd ../../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./build/bin/linux_64/*/x2t $out/bin

    mkdir -p $out/etc
    cat >$out/etc/DoctRenderer.config <<EOF
          <Settings>
            <file>${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/sdkjs/common/Native/native.js</file>
            <file>${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/sdkjs/common/Native/jquery_native.js</file>
            <allfonts>${allfonts}/converter/AllFonts.js</allfonts>
            <file>${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/web-apps/vendor/xregexp/xregexp-all-min.js</file>
            <sdkjs>${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/sdkjs</sdkjs>
            <dictionaries>${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/dictionaries</dictionaries>
          </Settings>
    EOF

    patchelf --add-rpath ${icu}/lib $out/bin/x2t

    runHook postInstall
  '';
  passthru.tests = {
    unicodeConverter = unicodeConverterTests;
    fb2file = fb2file.tests.run;
    x2t = runCommand "x2t-test" { } ''
      (${x2t}/bin/x2t || true) | grep "OOX/binary file converter." && mkdir -p $out
    '';
  };
  passthru.components = {
    inherit
      allfontsgen
      allfonts
      unicodeConverter
      kernel
      unicodeConverterTests
      graphics
      network
      docxformatlib
      cryptopp
      xlsbformatlib
      xlsformatlib
      doctrenderer
      htmlfile2
      epubfile
      fb2file
      iworkfile
      ;
  };
  meta = {
    description = "Convert files from one format to another";
    homepage = "https://github.com/ONLYOFFICE/core/tree/master/X2tConverter";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ raboof ];
    platforms = lib.platforms.all;
  };
})
