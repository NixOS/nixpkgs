{ stdenv
, lib
, fetchurl
, undmg
, writeScript
}:

let
  appName = "LibreOffice.app";
  version = "7.2.5";
  baseUrl = "https://download.documentfoundation.org/libreoffice/stable";
  dist = {
    aarch64-darwin = rec {
      arch = "aarch64";
      archSuffix = arch;
      url = "${baseUrl}/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "bdbcb9a98211f866ca089d440aebcd1d313aa99e8ab4104aae4e65ea3cee74ca";
    };

    x86_64-darwin = rec {
      arch = "x86_64";
      archSuffix = "x86-64";
      url = "${baseUrl}/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "0b7ef18ed08341ac6c15339fe9a161ad17f6b469009d987cfc7d50c628d12a4e";
    };
  };
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "libreoffice";
  src = fetchurl {
    inherit (dist."${stdenv.hostPlatform.system}") url sha256;
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

  passthru.updateScript =
    let
      inherit (import ./update-utils.nix { inherit lib; })
        getLatestStableVersion
        getSha256
        nullHash;
      newVersion = getLatestStableVersion;
      newAarch64Sha256 = getSha256 dist."aarch64-darwin".url version newVersion;
      newX86_64Sha256 = getSha256 dist."x86_64-darwin".url version newVersion;
    in
    writeScript "update-libreoffice.sh"
      ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p common-updater-scripts
        set -o errexit
        set -o nounset
        set -o pipefail
        
        # reset version first so that both platforms are always updated and in sync
        update-source-version libreoffice 0 ${nullHash} --system=aarch64-darwin
        update-source-version libreoffice ${newVersion} ${newAarch64Sha256} --system=aarch64-darwin
        update-source-version libreoffice 0 ${nullHash} --system=x86_64-darwin
        update-source-version libreoffice ${newVersion} ${newX86_64Sha256} --system=x86_64-darwin
      '';

  meta = with lib; {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ tricktron ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
}
