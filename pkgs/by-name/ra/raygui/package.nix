{
  stdenvNoCC,
  fetchFromGitHub,
  lib
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  name = "raygui";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raygui";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-1qnChZYsb0e5LnPhvs6a/R5Ammgj2HWFNe9625sBRo8=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{include,lib/pkgconfig}

    install -Dm644 $src/src/raygui.h $out/include/raygui.h

    cat <<EOF > $out/lib/pkgconfig/raygui.pc
    prefix=$out
    includedir=$out/include

    Name: raygui
    Description: ${finalAttrs.meta.description}
    URL: ${finalAttrs.meta.homepage}
    Version: ${finalAttrs.version}
    Cflags: -I"{includedir}"
    EOF

    runHook postInstall
  '';

  meta = {
    description = "A simple and easy-to-use immediate-mode gui library";
    homepage = "https://github.com/raysan5/raygui";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
  };
})
