{
  lib,
  stdenv,
  fetchurl,
  tcsh,
  coreutils,
  gzip,
  gnused,
  ncompress,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rnxcmp";
  version = "4.2.0";

  src = fetchurl {
    url = "https://terras.gsi.go.jp/ja/crx2rnx/RNXCMP_${finalAttrs.version}_src.tar.gz";
    hash = "sha256-mkUtKQiifFsxUsxCTgSIRyIcBl6X9rHxpYXHsMNPus4=";
  };

  patchPhase =
    let
      cat = lib.getExe' coreutils "cat";
      compress = lib.getExe' ncompress "compress";
      gzipExe = lib.getExe gzip;
      rm = lib.getExe' coreutils "rm";
      sed = lib.getExe gnused;
    in
    ''
      runHook prePatch

      substituteInPlace front-end-tools/unix/CRZ2RNX --replace-fail \
        '$CAT $file_in  | CRX2RNX - > $file_out' \
        '$CAT $file_in  | '"$out"'/bin/CRX2RNX - > $file_out'

      substituteInPlace front-end-tools/unix/RNX2CRZ \
        --replace-fail \
          '$CAT $file_in | RNX2CRX - | $COMPRESS -c > $file_out.$EXT' \
          '$CAT $file_in | '"$out"'/bin/RNX2CRX - | $COMPRESS -c > $file_out.$EXT' \
        --replace-fail \
          'set COMPRESS = gzip' \
          'set COMPRESS = ${gzipExe}' \
        --replace-fail \
          'set COMPRESS = compress' \
          'set COMPRESS = ${compress}' \

      substituteInPlace front-end-tools/unix/* \
        --replace-fail /bin/csh '${lib.getExe tcsh}' \
        --replace-fail \
          'set CAT = cat;' \
          'set CAT = ${cat};' \
        --replace-fail \
          "set CAT = 'gzip -dc'" \
          "set CAT = '${gzipExe} -dc'" \
        --replace-fail \
          ' sed -e ' \
          ' ${sed} -e ' \
        --replace-fail \
          'rm $file_in' \
          '${rm} $file_in'

      runHook postPatch
    '';

  buildPhase = ''
    runHook preBuild

    # Build commands taken from docs/RNXCMP.txt and adjusted
    "$CC" -O2 source/crx2rnx.c -o CRX2RNX
    "$CC" -O2 source/rnx2crx.c -o RNX2CRX

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m755 -t "$out/bin" CRX2RNX RNX2CRX front-end-tools/unix/*
    install -D -m755 -t "$out/share/doc" docs/*
    install -D -m755 -t "$out/share/licenses" docs/LICENSE.txt

    # The filesystem on macOS is case insensitive, so don't try to create
    # a symbolic link where only the case of the name is different.
    if [ ! -e "$out/bin/CRX2RNX" ]; then
      # rtkpost_qt wants crx2rnx instead of CRX2RNX
      ln --verbose --symbolic CRX2RNX "$out/bin/crx2rnx"
      ln --verbose --symbolic RNX2CRX "$out/bin/rnx2crx"
    fi

    runHook postInstall
  '';

  passthru.tests = {
    inherit (callPackage ./test.nix { }) crx crz rnx;
  };

  meta = {
    description = "Compression/restoration of RINEX observation files developed by Y. Hatanaka of GSI";
    homepage = "https://terras.gsi.go.jp/ja/crx2rnx.html";
    changelog = "https://terras.gsi.go.jp/ja/crx2rnx/CHANGES.txt";
    # The license text in docs/LICENSE.txt just refers to a website
    # (with one section excluded) and does not contain the actual license text.
    # The website also does not contain the full license text.
    # You need to refer to https://www.digital.go.jp/en/resources/open_data/public_data_license_v1.0 as well.
    # The license on the website is a modified version of the Public Data License (Version 1.0) (PDL 1.0).
    # The official license text is in Japanese. A "Data" license seems like an odd choice for software.
    # This license has seemingly not been approved by the FSF or the OSI.
    # It's still marked as free software since as far as I can tell, the
    # license does not disallow any of the Four Essential Freedoms as long
    # as modified versions of the software include a statement expressing
    # that the content has been edited and the source is cited.
    # The full PDL 1.0 license text also says that it is compatible
    # with the Creative Commons Attribution License 4.0.
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      Luflosi
    ];
  };
})
