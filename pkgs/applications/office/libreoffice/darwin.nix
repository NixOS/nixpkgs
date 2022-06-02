{ stdenv
, lib
, fetchurl
, undmg
}:

let
  appName = "LibreOffice.app";
  version = "7.2.5";
  dist = {
    aarch64-darwin = {
      arch = "aarch64";
      sha256 = "bdbcb9a98211f866ca089d440aebcd1d313aa99e8ab4104aae4e65ea3cee74ca";
    };

    x86_64-darwin = {
      arch = "x86_64";
      sha256 = "0b7ef18ed08341ac6c15339fe9a161ad17f6b469009d987cfc7d50c628d12a4e";
    };
  }."${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  inherit version;
  pname = "libreoffice";
  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${dist.arch}/LibreOffice_${version}_MacOS_${dist.arch}.dmg";
    inherit (dist) sha256;
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = "${appName}";
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstallPhase
    mkdir -p $out/{Applications/${appName},bin}
    cp -R . $out/Applications/${appName}
    ln -s $out/Applications/${appName}/Contents/MacOS/soffice $out/bin
    runHook postInstallPhase
  '';

  meta = with lib; {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ tricktron ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
}
