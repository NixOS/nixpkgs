{
  lib,
  stdenv,
  base16-schemes,
}:
stdenv.mkDerivation {
  pname = "base24-schemes";
  inherit (base16-schemes) version src;

  strictDeps = true;
  __structuredAttrs = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    install base24/*.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = base16-schemes.meta // {
    description = "Base24 color schemes from Tinted Theming";
    maintainers = with lib.maintainers; [ nyxar77 ];
  };
}
