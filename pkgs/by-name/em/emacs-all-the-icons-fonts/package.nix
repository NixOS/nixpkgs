{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "emacs-all-the-icons-fonts";
  version = "5.0.0";

  src = fetchzip {
    url = "https://github.com/domtronn/all-the-icons.el/archive/${version}.zip";
    hash = "sha256-70ysVxOey6NLlCwhEYhxpxO6uuarMFDpg3Efh+3bj1M=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/*.ttf -t $out/share/fonts/all-the-icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "Icon fonts for emacs all-the-icons";
    longDescription = ''
      The emacs package all-the-icons provides icons to improve
      presentation of information in emacs. This package provides
      the fonts needed to make the package work properly.
    '';
    homepage = "https://github.com/domtronn/all-the-icons.el";

    /*
      The fonts come under a mixture of licenses - the MIT license,
      SIL OFL license, and Apache license v2.0. See the GitHub page
      for further information.
    */
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ rlupton20 ];
  };
}
