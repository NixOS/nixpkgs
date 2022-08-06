{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "zecwallet-lite";
  version = "1.7.13";

  src = fetchurl {
    url = "https://github.com/adityapk00/zecwallet-lite/releases/download/v${version}/Zecwallet.Lite-${version}.AppImage";
    hash = "sha256-uBiLGHBgm0vurfvOJjJ+RqVoGnVccEHTFO2T7LDqUzU=";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "A fully featured shielded wallet for Zcash";
    homepage = "https://www.zecwallet.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ colinsane ];
    platforms = [ "x86_64-linux" ];
  };
}
