{
  lib,
  base16-schemes,
}:
base16-schemes.overrideAttrs (oldAttrs: {
  pname = "base24-schemes";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    install base24/*.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = oldAttrs.meta // {
    description = "All the color schemes for use in base24 packages";
    maintainers = [ lib.maintainers.nyxar77 ];
  };
})
