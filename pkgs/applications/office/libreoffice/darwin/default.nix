{ stdenvNoCC
, lib
, fetchurl
, undmg
, writeScript
, callPackage
}:

let
  appName = "LibreOffice.app";
  scriptName = "soffice";
  version = "7.3.3";

  dist = {
    aarch64-darwin = rec {
      arch = "aarch64";
      archSuffix = arch;
      url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "50ed3deb8d9c987516e2687ebb865bca15486c69da79f1b6d74381e43f2ec863";
    };

    x86_64-darwin = rec {
      arch = "x86_64";
      archSuffix = "x86-64";
      url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "fb2f9bb90eee34a22af3a2bf2854ef5b76098302b3c41d13d4f543f0d72b994f";
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "libreoffice";
  src = fetchurl {
    inherit (dist.${stdenvNoCC.hostPlatform.system} or
      (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}")) url sha256;
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = "${appName}";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications/${appName},bin}
    cp -R . $out/Applications/${appName}
    cat > $out/bin/${scriptName} << EOF
    #!${stdenvNoCC.shell}
    open -na $out/Applications/${appName} --args "$@"
    EOF
    chmod +x $out/bin/${scriptName}
    runHook postInstall
  '';

  passthru.updateScript =
    let
      defaultNixFile = builtins.toString ./default.nix;
      updateNix = builtins.toString ./update.nix;
      aarch64Url = dist."aarch64-darwin".url;
      x86_64Url = dist."x86_64-darwin".url;
    in
    writeScript "update-libreoffice.sh"
      ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash --argstr aarch64Url ${aarch64Url} --argstr x86_64Url ${x86_64Url} --argstr version ${version} ${updateNix}
        set -eou pipefail

        # reset version first so that both platforms are always updated and in sync
        update-source-version libreoffice-bin 0 ${lib.fakeSha256} --file=${defaultNixFile} --system=aarch64-darwin
        update-source-version libreoffice-bin $newVersion $newAarch64Sha256 --file=${defaultNixFile} --system=aarch64-darwin
        update-source-version libreoffice-bin 0 ${lib.fakeSha256} --file=${defaultNixFile} --system=x86_64-darwin
        update-source-version libreoffice-bin $newVersion $newX86_64Sha256 --file=${defaultNixFile} --system=x86_64-darwin
      '';

  meta = with lib; {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ tricktron ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
