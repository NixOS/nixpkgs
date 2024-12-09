{
  lib,
  stdenv,
  fetchurl,
  dpkg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "insync-emblem-icons";
  version = "3.8.7.50516";

  src = fetchurl rec {
    urls = [
      "https://cdn.insynchq.com/builds/linux/insync-emblem-icons_${finalAttrs.version}_all.deb"
      "https://web.archive.org/web/20240409081214/${builtins.elemAt urls 0}"
    ];
    hash = "sha256-uALaIxETEEkjDTx331uIsb4VswWk2K0dGuDMYH8v5U8=";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R usr/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ hellwolf ];
    homepage = "https://www.insynchq.com";
    description = "This package contains the file manager emblem icons for Insync file manager extensions";
  };
})
