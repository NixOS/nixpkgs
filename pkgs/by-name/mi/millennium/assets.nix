{
  lib,
  stdenv,

  millennium-src,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "millennium-assets";
  version = "2.35.0";

  src = millennium-src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/millennium/assets/
    cp -r src/pipx $out/share/millennium/assets/pipx

    runHook postInstall
  '';

  meta = {
    homepage = "https://steambrew.app/";
    license = lib.licenses.mit;
    description = "Python Assets for Millennium";

    maintainers = [
      lib.maintainers.trivaris
    ];

    platforms = [
      "x86_64-linux"
    ];
  };
})
