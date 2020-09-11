{ stdenv
, fetchurl
, rpmextract
, patchelf
, makeWrapper
, openssl
}:

stdenv.mkDerivation rec {
  pname = "snowsql";
  version = "1.2.5";

  src = fetchurl {
    url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowflake-snowsql-1.2.5-1.x86_64.rpm";
    sha256 = "c66e2044640197f4a5b5a16b89e8e7c6a816aa539004a0fb016aab185795f2d5";
  };

  nativeBuildInputs = [ rpmextract makeWrapper ];

  libPath =
    stdenv.lib.makeLibraryPath
      [
        openssl
      ];

  buildCommand = ''
    mkdir -p $out/bin/
    cd $out
    rpmextract $src
    rm -R usr/bin
    mv usr/* $out
    rmdir usr

    ${patchelf}/bin/patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        lib64/snowflake/snowsql/snowsql

    makeWrapper $out/lib64/snowflake/snowsql/snowsql $out/bin/snowsql \
      --set LD_LIBRARY_PATH "${libPath}":"${placeholder "out"}"/lib64/snowflake/snowsql \

  '';

  meta = with stdenv.lib; {
    description = "Command line client for the Snowflake database";
    homepage = "https://www.snowflake.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ andehen ];
    platforms = [ "x86_64-linux" ];
  };
}
