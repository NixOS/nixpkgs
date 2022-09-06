{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "zecwallet";
  version = "1.8.3";

  src = fetchurl {
    url = "https://github.com/ZcashFoundation/zecwallet/releases/download/v${version}/Zecwallet.Fullnode-${version}.AppImage";
    hash = "sha256-yUhtEbDryN304wKjFVoXKima+10InBjJstQgk8xLiz8=";
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
    description = "A fully featured shielded wallet for Zcash with embedded zcash node";
    homepage = "https://www.zecwallet.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethindp ];
    platforms = [ "x86_64-linux" ];
  };
}
