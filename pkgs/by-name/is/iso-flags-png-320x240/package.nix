{
  iso-flags,
}:

iso-flags.overrideAttrs (oldAttrs: {
  buildFlags = [ "png-country-320x240-fancy" ];
  installPhase = ''
    runHook preInstall
      mkdir -p $out/share && mv build/png-country-4x2-fancy/res-320x240 $out/share/iso-flags-png
      runHook postInstall
  '';
})
