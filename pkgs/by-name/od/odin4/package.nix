{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
}:
stdenv.mkDerivation {
  pname = "odin4";
  version = "1.2.1-dc05e3ea";

  src = fetchzip {
    # https://xdaforums.com/t/official-samsung-odin-v4-1-2-1-dc05e3ea-for-linux.4453423/#post-86977569
    url = "https://web.archive.org/web/20230225072710if_/https://forum.xda-developers.com/attachments/odin-zip.5629297/";
    hash = "sha256-SoznK53UD/vblqeXBLRlkokaLJwhMZy7wqKufR0I8hI=";
    extension = "zip";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin odin4
    runHook postInstall
  '';

  meta = {
    description = "Firmware flasher for Samsung devices";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "odin4";
  };
}
