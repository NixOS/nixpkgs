{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-matrix-theme";
  version = "0.1.0-unstable-2017-02-19";

  src = fetchFromGitHub {
    owner = "storax";
    repo = "plymouth-matrix-theme";
    rev = "b2268f25dea7537ed5709b00d5a83b3600265c54";
    hash = "sha256-JmMmpw1By5U6OTaSPnJOZZxrieSnXivMmdt/JPazjpI=";
  };

  postPatch = ''
    # Remove not needed files
    rm README.rst LICENSE Makefile
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/matrix
    cp * $out/share/plymouth/themes/matrix
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Plymouth boot theme inspired by Matrix";
    longDescription = ''
      A very simple boot animation that emulates
      Trinity hacking Neo's computer at the
      beginning of The Matrix (1999).
    '';
    homepage = "https://github.com/storax/plymouth-matrix-theme";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
