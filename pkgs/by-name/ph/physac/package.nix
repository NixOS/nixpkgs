{
  stdenvNoCC,
  fetchFromGitHub,
  lib
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "physac";
  version = "2.5-unstable-2023-12-11";

  src = fetchFromGitHub {
    owner = "victorfisac";
    repo = "Physac";
    rev = "29d9fc06860b54571a02402fff6fa8572d19bd12";
    hash = "sha256-PTlV1tT0axQbmGmJ7JD1n6wmbIxUdu7xho78EO0HNNk=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{include,lib/pkgconfig}

    install -Dm644 $src/src/physac.h $out/include/physac.h

    cat <<EOF > $out/lib/pkgconfig/physac.pc
    prefix=$out
    includedir=$out/include

    Name: physac
    Description: ${finalAttrs.meta.description}
    URL: ${finalAttrs.meta.homepage}
    Version: ${finalAttrs.version}
    Cflags: -I"{includedir}"
    EOF

    runHook postInstall
  '';

  meta = {
    description = "2D physics header-only library for raylib";
    homepage = "https://github.com/victorfisac/Physac";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
  };
})
