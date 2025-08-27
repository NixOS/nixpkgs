{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "socklog";
  version = "2.1.1";

  src = fetchurl {
    url = "https://smarden.org/socklog/socklog-${finalAttrs.version}.tar.gz";
    hash = "sha256-6xk3JB1seyoEArSf/evwIrsvzaPgDBsaF66Lzx5KObo=";
  };

  sourceRoot = "admin/socklog-${finalAttrs.version}";

  outputs = [
    "out"
    "man"
    "doc"
  ];

  postPatch = ''
    # Fails to run as user without supplementary groups
    echo "int main() { return 0; }" >src/chkshsgr.c
  '';

  configurePhase = ''
    echo "$NIX_CC/bin/cc $NIX_CFLAGS_COMPILE"   >src/conf-cc
    echo "$NIX_CC/bin/cc -s"                    >src/conf-ld
  '';

  buildPhase = "package/compile";

  installPhase = ''
    mkdir -p $out/bin
    mv command"/"* $out/bin

    for i in {1,8} ; do
      mkdir -p $man/share/man/man$i
      mv man"/"*.$i $man/share/man/man$i
    done

    mkdir -p $doc/share/doc/socklog/html
    mv doc/*.html $doc/share/doc/socklog/html/
  '';

  checkPhase = "package/check";

  doCheck = true;

  # Needed for tests
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "System and kernel logging services";
    homepage = "https://smarden.org/socklog/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ joachifm ];
  };
})
