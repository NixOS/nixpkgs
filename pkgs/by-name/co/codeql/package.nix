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
in
stdenv.mkDerivation rec {
  pname = "codeql";
  version = "2.27.3";

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  src = fetchzip {
    url = "https://github.com/github/codeql-cli-binaries/releases/download/v${version}/codeql-${platform}.zip";
    hash =
      {
        x86_64-linux = "sha256-MefrnCcVjue8WJL+zoIewe/gV2mNWsV9KJWVwM2AlfM=";
        aarch64-linux = "sha256-hv2m9F1Ex10hSXlNUGL/R4Xpfy/aKtg4mUIdazLl7c4=";
        x86_64-darwin = "sha256-9DCBMMWDjNvPE5k4PFXPndMvsAONGvvSdLWkcVmHtUU=";
        aarch64-darwin = "sha256-9DCBMMWDjNvPE5k4PFXPndMvsAONGvvSdLWkcVmHtUU=";
      }
      .${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = [ autoPatchelfHook ];

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
    alsa-lib
    lttng-ust_2_12
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
    ln -s ${jdk21} $out/codeql/tools/linux64/java

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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    license = lib.licenses.unfree;
  };
}
