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
  version = "3.12.0";
  src = fetchurl {
    url = "https://download.memgraph.com/memgraph/v${finalAttrs.version}/debian-13${lib.optionalString stdenv.hostPlatform.isAarch64 "-aarch64"}/memgraph_${finalAttrs.version}-1_${
      {
        "x86_64-linux" = "amd64";
        "aarch64-linux" = "arm64";
      }
      .${stdenv.hostPlatform.system}
    }.deb";
    hash =
      {
        "x86_64-linux" = "sha256-4GGp2A8X9FZcW71hZ9SAlI8c/ulJrH94TKhRbDAYOpU=";
        "aarch64-linux" = "sha256-JQ6pnKNdK1nIxIG4SP2m6/AHcY6ln73xwYfkP6czHt8=";
      }
      .${stdenv.hostPlatform.system} or lib.fakeHash;
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

  meta = with lib; {
    description = "High-performance open-source in-memory graph database";
    homepage = "https://memgraph.com/";
    changelog = "https://memgraph.com/docs/release-notes";
    mainProgram = "memgraph";
    license = licenses.bsl11;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ kip93 ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
