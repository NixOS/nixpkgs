{
  lib,
  stdenv,
  fetchzip,
  zlib,
  xorg,
  freetype,
  jdk17,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.23.0";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql.zip";
    hash = "sha256-8T1aOy2okhwj2rFz3jUpUm2JaJcrXdB6KpSD8btCEx4=";
  };

  nativeBuildInputs = [
    zlib
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXtst
    xorg.libXrender
    freetype
    jdk17
    (lib.getLib stdenv.cc.cc)
    curl
  ];

  installPhase = ''
    # codeql directory should not be top-level, otherwise,
    # it'll include /nix/store to resolve extractors.
    mkdir -p $out/{codeql,bin}
    cp -R * $out/codeql/

    ln -sf $out/codeql/tools/linux64/lib64trace.so $out/codeql/tools/linux64/libtrace.so

    # many of the codeql extractors use CODEQL_DIST + CODEQL_PLATFORM to
    # resolve java home, so to be able to create databases, we want to make
    # sure that they point somewhere sane/usable since we can not autopatch
    # the codeql packaged java dist, but we DO want to patch the extractors
    # as well as the builders which are ELF binaries for the most part
    rm -rf $out/codeql/tools/linux64/java
    ln -s ${jdk17} $out/codeql/tools/linux64/java

    ln -s $out/codeql/codeql $out/bin/
  '';

  meta = with lib; {
    description = "Semantic code analysis engine";
    homepage = "https://codeql.github.com";
    maintainers = [ maintainers.dump_stack ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = licenses.unfree;
  };
}
