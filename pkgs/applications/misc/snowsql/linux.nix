{
  lib,
  stdenv,
  fetchurl,
  rpmextract,
  makeWrapper,
  openssl,
  libxcrypt-legacy,
  zlib,
  version,
  pname,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit pname version meta;
  src = fetchurl {
    url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/${lib.versions.majorMinor finalAttrs.version}/linux_x86_64/snowflake-snowsql-${finalAttrs.version}-1.x86_64.rpm";
    sha256 = "28a0828fea48c1686eccebb196343c635d660300ff18e36ca5b5ee3c03017611";
  };

  nativeBuildInputs = [
    rpmextract
    makeWrapper
  ];

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    mv usr/lib64/snowflake/snowsql/* $out/lib/
  '';

  libPath = lib.makeLibraryPath [
    openssl
    libxcrypt-legacy
    zlib
  ];

  preFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/lib/snowsql
  '';

  postFixup = ''
    makeWrapper $out/lib/snowsql $out/bin/snowsql \
      --set LD_LIBRARY_PATH "${finalAttrs.libPath}":"$out/lib"
  '';
})
