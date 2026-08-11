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
    url = "https://download.documentfoundation.org/libreoffice/stable/${version}/mac/aarch64/LibreOffice_${version}_MacOS_aarch64.dmg";
    sha256 = "64e0ad05564554eeee639d49b08b20908a38d4722ec95f1620d05c99bcbe9fb1";
  };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "libreoffice";
  src = fetchurl {
    inherit (dist)
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
    in
    writeScript "update-libreoffice.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash --argstr url ${dist.url} --argstr version ${version} ${updateNix}
      set -eou pipefail

      update-source-version libreoffice-bin $newVersion $newSha256 --file=${defaultNixFile} --ignore-same-version
    '';

  meta = {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ tricktron ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
    ];
  };
}
