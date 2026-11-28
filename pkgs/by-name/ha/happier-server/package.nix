{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
}:

let
  inherit (stdenv.hostPlatform) system;

  pname = "happier-server";
  version = "0.2.0";

  sources = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/server-v${version}/happier-server-v${version}-darwin-arm64.tar.gz";
      hash = "sha256-TT1tZ0N5YvMPl4MuAz2gG5mOKZEBszVkpt74uHhwsbg=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/server-v${version}/happier-server-v${version}-linux-arm64.tar.gz";
      hash = "sha256-EIRHvDL3GE+RgC18dWUo7v4gK/RhIbzcgnpWNa+jhjI=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/server-v${version}/happier-server-v${version}-darwin-x64.tar.gz";
      hash = "sha256-Cw9bWPlIccqcUkpvQKMe4kScuRHopmWxKhAYmT7EoHM=";
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/server-v${version}/happier-server-v${version}-linux-x64.tar.gz";
      hash = "sha256-ZAg+3bsYHM1KERNnApWUVnDXvdMLhqNC7Pa5iI6gvvI=";
    };
  };
  platforms = builtins.attrNames sources;
  prismaEngineName =
    if stdenv.hostPlatform.isAarch64 then
      "libquery_engine-linux-arm64-openssl-3.0.x.so.node"
    else
      "libquery_engine-debian-openssl-3.0.x.so.node";
in

stdenv.mkDerivation {
  inherit pname version;

  strictDeps = true;

  src =
    if builtins.elem system platforms then
      sources.${system}
    else
      throw "Source for happier-server is not available for ${system}";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack

    tar --warning=no-unknown-keyword -xzf $src
    sourceRoot=happier-server-v${version}-${stdenv.hostPlatform.parsed.kernel.name}-${
      if stdenv.hostPlatform.isAarch64 then "arm64" else "x64"
    }

    runHook postUnpack
  '';

  # strip removes the payload embedded in Bun standalone executables.
  dontStrip = true;

  postPatch = ''
    find . -name '._*' -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/happier-server
    cp -r . $out/lib/happier-server/
    ln -s $out/lib/happier-server/happier-server $out/bin/happier-server

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      for prismaClient in \
        $out/lib/happier-server/generated/mysql-client \
        $out/lib/happier-server/generated/sqlite-client \
        $out/lib/happier-server/node_modules/.prisma/client
      do
        ln -s ${prismaEngineName} "$prismaClient/libquery_engine-linux-nixos.so.node"
      done
    ''}

    runHook postInstall
  '';

  meta = {
    description = "Self-hostable relay server for Happier";
    homepage = "https://github.com/happier-dev/happier";
    changelog = "https://github.com/happier-dev/happier/releases/tag/server-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imalison ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit platforms;
    mainProgram = "happier-server";
  };
}
