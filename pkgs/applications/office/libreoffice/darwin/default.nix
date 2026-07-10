{
  stdenvNoCC,
  lib,
  fetchurl,
  undmg,
  writeScript,
}:

let
  appName = "LibreOffice.app";
  scriptName = "soffice";
  version = "26.2.4";

  dist = {
    aarch64-darwin = rec {
      arch = "aarch64";
      archSuffix = arch;
      url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "64e0ad05564554eeee639d49b08b20908a38d4722ec95f1620d05c99bcbe9fb1";
    };

    x86_64-darwin = rec {
      arch = "x86_64";
      archSuffix = "x86-64";
      url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${archSuffix}.dmg";
      sha256 = "f92ba40fdada173232fe929bf77973a1ffcccec55ae7971957a6de84d33f0f1e";
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "libreoffice";
  src = fetchurl {
    inherit
      (dist.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}")
      )
      url
      sha256
      ;
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = appName;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications/${appName},bin}
    cp -R . $out/Applications/${appName}
    cat > $out/bin/${scriptName} << EOF
    #!${stdenvNoCC.shell}
    open -na $out/Applications/${appName} --args "\$@"
    EOF
    chmod +x $out/bin/${scriptName}
    runHook postInstall
  '';

  passthru.updateScript =
    let
      defaultNixFile = toString ./default.nix;
      updateNix = toString ./update.nix;
      aarch64Url = dist."aarch64-darwin".url;
      x86_64Url = dist."x86_64-darwin".url;
    in
    writeScript "update-libreoffice.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash --argstr aarch64Url ${aarch64Url} --argstr x86_64Url ${x86_64Url} --argstr version ${version} ${updateNix}
      set -eou pipefail

      update-source-version libreoffice-bin $newVersion $newAarch64Sha256 --file=${defaultNixFile} --system=aarch64-darwin --ignore-same-version
      update-source-version libreoffice-bin $newVersion $newX86_64Sha256 --file=${defaultNixFile} --system=x86_64-darwin --ignore-same-version
    '';

  meta = {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ tricktron ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
