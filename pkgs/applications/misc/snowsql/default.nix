{ lib
, stdenv
, fetchurl
, rpmextract
, patchelf
, makeWrapper
, openssl
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "snowsql";
  majorVersion = "1.2";
  version = "${majorVersion}.23";

  src = fetchurl {
    url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/${majorVersion}/linux_x86_64/snowflake-snowsql-${version}-1.x86_64.rpm";
    sha256 = "16zx30l3g5i5ndgxsqlkmkrfzswbczpb3jcya3psq5170i8cfm8f";
  };

  nativeBuildInputs = [ rpmextract makeWrapper ];

  libPath = lib.makeLibraryPath [ openssl libxcrypt ];

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

  meta = with lib; {
    description = "Command line client for the Snowflake database";
    homepage = "https://www.snowflake.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ andehen ];
    platforms = [ "x86_64-linux" ];
  };
}
