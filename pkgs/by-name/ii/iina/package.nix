{ lib
, fetchurl
, stdenvNoCC
, darwin
, nix-update-script
}:

darwin.installBinaryPackage rec {
  pname = "iina";
  version = "1.3.4";

  src = fetchurl {
    url = "https://github.com/iina/iina/releases/download/v${version}/IINA.v${version}.dmg";
    hash = "sha256-feUPWtSi/Vsnv1mjGyBgB0wFMxx6r6UzrUratlAo14w=";
  };

  appName = "IINA.app";
  sourceRoot = "IINA";

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/Applications/IINA.app/Contents/MacOS/${meta.mainProgram} $out/bin/${meta.mainProgram}
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://iina.io/";
    description = "The modern media player for macOS";
    license = licenses.gpl3;
    mainProgram = "iina-cli";
    maintainers = with maintainers; [ arkivm stepbrobd ];
  };
}
