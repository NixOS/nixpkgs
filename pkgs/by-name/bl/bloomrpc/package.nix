{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "bloomrpc";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/uw-labs/bloomrpc/releases/download/${finalAttrs.version}/BloomRPC-${finalAttrs.version}.AppImage";
    name = "bloomrpc-${finalAttrs.version}.AppImage";
    hash = "sha512-PebdYDpcplPN5y3mRu1mG6CXenYfYvBXNLgIGEr7ZgKnR5pIaOfJNORSNYSdagdGDb/B1sxuKfX4+4f2cqgb6Q==";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/bloomrpc.desktop $out/share/applications/bloomrpc.desktop
    install -m 444 -D ${finalAttrs.contents}/bloomrpc.png \
      $out/share/icons/hicolor/512x512/apps/bloomrpc.png
    substituteInPlace $out/share/applications/bloomrpc.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=bloomrpc'
  '';

  meta = {
    description = "GUI Client for GRPC Services";
    longDescription = ''
      Inspired by Postman and GraphQL Playground BloomRPC aims to provide the simplest
      and most efficient developer experience for exploring and querying your GRPC services.
    '';
    homepage = "https://github.com/uw-labs/bloomrpc";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ zoedsoupe ];
    platforms = [ "x86_64-linux" ];
  };
})
