{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  libseccomp,
  libuuid,
  openssl,
  python313,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "memgraph";
  version = "3.13.2";
  src = fetchurl {
    url = "https://download.memgraph.com/memgraph/v${finalAttrs.version}/${
      {
        "x86_64-linux" = "x86_64";
        "aarch64-linux" = "aarch64";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
    }-deb/memgraph_${finalAttrs.version}-1_${
      {
        "x86_64-linux" = "amd64";
        "aarch64-linux" = "arm64";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
    }.deb";
    hash =
      {
        "x86_64-linux" = "sha256-6ei6JcBFymZB3z74F9iOpPNCEPx7qATrYXhx9eQ/Vvo=";
        "aarch64-linux" = "sha256-BMIVO3YyAwgmkvr4TuBNqriD3v8gjkWxHpl4jC+ogcA=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];
  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    libseccomp
    libuuid
    openssl
    python313
  ];

  unpackPhase = ''
    dpkg -X $src .
  '';
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out

    mv ./etc $out/etc
    mv ./usr/bin $out/bin
    mv ./usr/include $out/include
    mv ./usr/lib $out/lib
    mv ./usr/share $out/share

    ln -sf ../lib/memgraph/memgraph $out/bin
  '';

  passthru.tests = {
    inherit (nixosTests) memgraph;
  };

  meta = {
    description = "High-performance open-source in-memory graph database";
    homepage = "https://memgraph.com/";
    changelog = "https://memgraph.com/docs/release-notes";
    mainProgram = "memgraph";
    license = lib.licenses.bsl11;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ kip93 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
