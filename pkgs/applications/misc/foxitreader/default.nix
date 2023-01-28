{ mkDerivation, lib, fetchzip, libarchive, autoPatchelfHook, libsecret, libGL, zlib, openssl, qtbase, qtwebkit, qtxmlpatterns }:

mkDerivation rec {
  pname = "foxitreader";
  version = "2.4.4.0911";

  src = fetchzip {
    url = "https://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/linux/${lib.versions.major version}.x/${lib.versions.majorMinor version}/en_us/FoxitReader.enu.setup.${version}.x64.run.tar.gz";
    sha256 = "0ff4xs9ipc7sswq0czfhpsd7qw7niw0zsf9wgsqhbbgzcpbdhcb7";
    stripRoot = false;
  };

  buildInputs = [ libGL libsecret openssl qtbase qtwebkit qtxmlpatterns zlib ];

  nativeBuildInputs = [ autoPatchelfHook libarchive ];

  buildPhase = ''
    runHook preBuild

    input_file=$src/*.run
    mkdir -p extracted
    # Look for all 7z files and extract them
    grep --only-matching --byte-offset --binary \
      --text -P '7z\xBC\xAF\x27\x1C\x00\x03' $input_file | cut -d: -f1 |
      while read position; do
        tail -c +$(($position + 1)) $input_file > file.7z
        bsdtar xf file.7z -C extracted
      done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cd extracted

    cp -r  \
      CollectStrategy.txt \
      cpdf_settings \
      fxplugins \
      lang \
      resource \
      run \
      stamps \
      welcome \
      Wrappers \
      $out/lib/

    patchelf $out/lib/fxplugins/librms.so \
      --replace-needed libssl.so.10 libssl.so \
      --replace-needed libcrypto.so.10 libcrypto.so

    # FIXME: Doing this with one invocation is broken right now
    patchelf $out/lib/fxplugins/librmscrypto.so \
      --replace-needed libssl.so.10 libssl.so
    patchelf $out/lib/fxplugins/librmscrypto.so \
      --replace-needed libcrypto.so.10 libcrypto.so

    install -D -m 755 FoxitReader -t $out/bin

    # Install icon and desktop files
    install -D -m 644 images/FoxitReader.png -t $out/share/pixmaps/
    install -D -m 644 FoxitReader.desktop -t $out/share/applications/
    echo Exec=FoxitReader %F >> $out/share/applications/FoxitReader.desktop

    runHook postInstall
  '';

  qtWrapperArgs = [ "--set appname FoxitReader" "--set selfpath $out/lib" ];

  meta = with lib; {
    description = "A viewer for PDF documents";
    homepage = "https://www.foxitsoftware.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ p-h rhoriguchi ];
  };
}
