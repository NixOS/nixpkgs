{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "bloomrpc";
  version = "1.5.3";

  src = fetchurl {
    url = "https://github.com/uw-labs/${finalAttrs.pname}/releases/download/${finalAttrs.version}/BloomRPC-${finalAttrs.version}.AppImage";
    name = "${finalAttrs.pname}-${finalAttrs.version}.AppImage";
    hash = "sha512-PebdYDpcplPN5y3mRu1mG6CXenYfYvBXNLgIGEr7ZgKnR5pIaOfJNORSNYSdagdGDb/B1sxuKfX4+4f2cqgb6Q==";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/${finalAttrs.pname}.desktop $out/share/applications/${finalAttrs.pname}.desktop
    install -m 444 -D ${finalAttrs.contents}/${finalAttrs.pname}.png \
      $out/share/icons/hicolor/512x512/apps/${finalAttrs.pname}.png
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
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
