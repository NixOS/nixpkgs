# Metapacote: reúne os CLIs em um único perfil.
{ lib, symlinkJoin, version ? "0.1.0", packages, contentAddressed ? false }:

symlinkJoin ({
  name = "arkhe-${version}";
  paths = packages;

  meta = {
    description = "Conjunto de CLIs Arkhe";
    homepage = "https://github.com/rafael-arkhe/nixpkgs-arkhe";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
} // lib.optionalAttrs contentAddressed {
  __contentAddressed = true;
  outputHashMode = "recursive";
})
