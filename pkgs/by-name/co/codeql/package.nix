{
  lib,
  stdenv,
  fetchzip,
  zlib,
  libxtst,
  libxrender,
  libxi,
  libxext,
  libx11,
  freetype,
  jdk21,
  curl,
  autoPatchelfHook,
  alsa-lib,
  lttng-ust_2_12,
}:

let
  platform =
    if stdenv.hostPlatform.isDarwin then
      "osx64"
    else if stdenv.hostPlatform.isAarch64 then
      "linux-arm64"
    else
      "linux64";

  toolsDir = "codeql/tools/${platform}";

  javaDir = "java";
in
stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.27.5";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql-${platform}.zip";
    hash =
      {
        x86_64-linux = "sha256-91hjL1U4C6LklkUmVISr+J21zbtvfnIH5e+mpjYFf04=";
        aarch64-linux = "sha256-1W4sQ44gH10V+DgpfZ8Q9Nl0qaiJ8Wnjh+mOz2kX5BY=";
        aarch64-darwin = "sha256-An3mrL3qzuDeFmFKZEh+I+xxLDG1IouuSIjU/vdLEN0=";
      }
      .${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    zlib
    libx11
    libxext
    libxi
    libxtst
    libxrender
    freetype
    jdk21
    (lib.getLib stdenv.cc.cc)
    curl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    lttng-ust_2_12
  ];

  installPhase = ''
    # codeql directory should not be top-level, otherwise,
    # it'll include /nix/store to resolve extractors.
    mkdir -p $out/{codeql,bin}
    cp -R * $out/codeql/

    if [ -e $out/${toolsDir}/lib64trace.so ]; then
      ln -sf $out/${toolsDir}/lib64trace.so $out/${toolsDir}/libtrace.so
    fi

    # many of the codeql extractors use CODEQL_DIST + CODEQL_PLATFORM to
    # resolve java home, so to be able to create databases, we want to make
    # sure that they point somewhere sane/usable since we can not autopatch
    # the codeql packaged java dist, but we DO want to patch the extractors
    # as well as the builders which are ELF binaries for the most part
    rm -rf $out/${toolsDir}/${javaDir}
    ln -s ${jdk21} $out/${toolsDir}/${javaDir}

    ln -s $out/codeql/codeql $out/bin/
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    # Confirm that "codeql database create" runs successfully.
    tmpdir=$(mktemp -d)
    echo "int main() { return 0; }" > "$tmpdir/test.c"
    $out/bin/codeql database create "$tmpdir/codeql-db" \
      --language=cpp --source-root="$tmpdir" \
      --command="cc $tmpdir/test.c"
  '';

  meta = {
    description = "Semantic code analysis engine";
    homepage = "https://codeql.github.com";
    maintainers = with lib.maintainers; [
      dump_stack
      tree-sapii
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    license = lib.licenses.unfree;
  };
}
