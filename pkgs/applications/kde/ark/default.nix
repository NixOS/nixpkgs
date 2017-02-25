{
  kdeApp, lib, kdeWrapper,

  ecm, kdoctools, makeWrapper,

  karchive, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, khtml, kio,
  kservice, kpty, kwidgetsaddons, libarchive,

  # Archive tools
  p7zip, unrar, unzipNLS, zip
}:

let
  unwrapped =
    kdeApp {
      name = "ark";
      nativeBuildInputs = [
        ecm kdoctools makeWrapper
      ];
      propagatedBuildInputs = [
        khtml ki18n kio karchive kconfig kcrash kdbusaddons kiconthemes kservice
        kpty kwidgetsaddons libarchive
      ];
      postInstall =
        let
          PATH = lib.makeBinPath [
            p7zip unrar unzipNLS zip
          ];
        in ''
          wrapProgram "$out/bin/ark" \
              --prefix PATH : "${PATH}"
        '';
      meta = {
        license = with lib.licenses; [ gpl2 lgpl3 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
    };
in
kdeWrapper
{
  inherit unwrapped;
  targets = [ "bin/ark" ];
}
