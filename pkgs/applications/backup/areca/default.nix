{ lib, stdenv, fetchurl, ant, jre, jdk, swt, acl, attr }:

stdenv.mkDerivation rec {
  pname = "areca";
  version = "7.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/areca/areca-stable/areca-${version}/areca-${version}-src.tar.gz";
    sha256 = "1q4ha9s96c1syplxm04bh1v1gvjq16l4pa8w25w95d2ywwvyq1xb";
  };

  sourceRoot = ".";

  buildInputs = [ jdk ant acl attr ];

  patches = [ ./fix-javah-bug.diff ];

  postPatch = ''
    substituteInPlace build.xml --replace "/usr/lib/java/swt.jar" "${swt}/jars/swt.jar"
    substituteInPlace build.xml --replace "gcc" "${stdenv.cc}/bin/gcc"
    substituteInPlace areca.sh --replace "bin/" ""
    substituteInPlace bin/areca_run.sh --replace "/usr/java" "${jre}/lib/openjdk"
    substituteInPlace bin/areca_run.sh --replace "/usr/lib/java/swt.jar" "${swt}/jars/swt.jar"

    # Fix for NixOS/nixpkgs/issues/53716
    sed -i -e 's;^;#include <attr/attributes.h>;' jni/com_myJava_file_metadata_posix_jni_wrapper_FileAccessWrapper.c
    substituteInPlace jni/com_myJava_file_metadata_posix_jni_wrapper_FileAccessWrapper.c --replace attr/xattr.h sys/xattr.h

    sed -i "s#^PROGRAM_DIR.*#PROGRAM_DIR=$out#g" bin/areca_run.sh
    sed -i "s#^LIBRARY_PATH.*#LIBRARY_PATH=$out/lib:${lib.makeLibraryPath [ swt acl ]}#g" bin/areca_run.sh

    # https://sourceforge.net/p/areca/bugs/563/
    substituteInPlace bin/areca_run.sh --replace '[ "$JAVA_IMPL" = "java" ]' \
      '[[ "$JAVA_IMPL" = "java" || "$JAVA_IMPL" = "openjdk" ]]'
  '';

  buildPhase = "ant";

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/translations
    cp areca.sh $out/bin/areca
    cp -r bin $out
    cp -r lib $out
    cp -r translations $out
    cp COPYING $out
  '';

  meta = with lib; {
    homepage = "http://www.areca-backup.org/";
    description = "An Open Source personal backup solution";
    # Builds fine but fails to launch.
    broken = true;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
