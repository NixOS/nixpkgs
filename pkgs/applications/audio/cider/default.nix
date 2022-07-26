{ appimageTools, lib, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "cider";
  version = "1.4.1.1680";

  src = fetchurl {
    url = "https://github.com/ciderapp/cider-releases/releases/download/v${version}/Cider-${builtins.concatStringsSep "." (lib.take 3 (lib.splitVersion version))}-alpha.${builtins.elemAt (lib.splitVersion version) 3}.AppImage";
    sha256 = "sha256-hEv+vfMMH+Trwa1UF5R8EtyYeyiRVLP0BrXOK2+1q8M=";
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
    description = "A new look into listening and enjoying Apple Music in style and performance.";
    homepage = "https://github.com/ciderapp/Cider";
    license = licenses.agpl3;
    maintainers = [ maintainers.cigrainger ];
    platforms = [ "x86_64-linux" ];
  };
}
