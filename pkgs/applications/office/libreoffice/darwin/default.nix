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
  version = "7.4.7";

  dist = {
    aarch64-darwin = rec {
      arch = "aarch64";
      archSuffix = arch;
      url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "d02513c6a58f35cb0da6880f76be3f4b3a620daaa9ce5c244d6efc40ed26a273";
    };

    x86_64-darwin = rec {
      arch = "x86_64";
      archSuffix = "x86-64";
      url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "c8ae0cbaa043b30718a4ac0ca93369e887fe6a46bb3618cea054bffaafd8b8e2";
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
