{
  stdenvNoCC,
  fetchurl,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "plymouth-blahaj-theme";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/190n/plymouth-blahaj/releases/download/v${version}/blahaj.tar.gz";
    sha256 = "sha256-JSCu/3SK1FlSiRwxnjQvHtPGGkPc6u/YjaoIvw0PU8A=";
  };

  patchPhase = ''
    runHook prePatch

    shopt -s extglob

    # deal with all the non ascii stuff
    mv !(*([[:graph:]])) blahaj.plymouth
    sed -i 's/\xc3\xa5/a/g' blahaj.plymouth
    sed -i 's/\xc3\x85/A/g' blahaj.plymouth

    runHook postPatch
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/blahaj
    cp * $out/share/plymouth/themes/blahaj
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;

    runHook postInstall
  '';

  meta = {
    description = "Plymouth theme featuring IKEA's 1m soft toy shark";
    homepage = "https://github.com/190n/plymouth-blahaj";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ miampf ];
  };
}
