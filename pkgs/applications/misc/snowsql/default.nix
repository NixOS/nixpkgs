{ lib, stdenv
, fetchurl
, rpmextract
, patchelf
, makeWrapper
, openssl
}:

stdenv.mkDerivation rec {
  pname = "snowsql";
  majorVersion = "1.2";
  version = "${majorVersion}.9";

  src = fetchurl {
    url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/${majorVersion}/linux_x86_64/snowflake-snowsql-${version}-1.x86_64.rpm";
    sha256 = "1k9dyr4vyqivpg054kbvs0jdwhbqbmlp9lsyxgazdsviw8ch70c8";
  };

  nativeBuildInputs = [ rpmextract makeWrapper ];

  libPath = lib.makeLibraryPath [ openssl ];

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
    license = licenses.unfree;
    maintainers = with maintainers; [ andehen ];
    platforms = [ "x86_64-linux" ];
  };
}
