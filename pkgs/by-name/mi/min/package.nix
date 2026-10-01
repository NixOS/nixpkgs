{
  lib,
  buildNimPackage,
  fetchFromSourcehut,
  openssl,
  pcre,
}:

buildNimPackage (finalAttrs: {
  pname = "min";
  version = "0.48.1";

  src = fetchFromSourcehut {
    owner = "~h3rald";
    repo = "min";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MWeyyCZ4jB4iUG7wj2egGMoXhcktcRvam2ym6ZsaGSo=";
  };

  lockFile = ./lock.json;

  buildInputs = [
    openssl
    pcre
  ];

  prePatch = ''
    # remove vendorabilities
    find . -name '*.a' -delete
    find minpkg/lib -name '*.nim' \
      -exec sed 's|{\.passL:.*\.}|discard|g' -i {} \;
  '';

  env.NIX_LDFLAGS = toString [ "-lpcre" ];

  meta = {
    description = "Functional, concatenative programming language with a minimalist syntax";
    homepage = "https://min-lang.org/";
    license = lib.licenses.mit;
    mainProgram = "min";
  };

})
