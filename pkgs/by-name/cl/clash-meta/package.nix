{ mihomo }:

mihomo.overrideAttrs (finalAttrs: previousAttrs: {
  pname = "clash-meta";

  postInstall = ''
    mv $out/bin/${previousAttrs.meta.mainProgram} $out/bin/${finalAttrs.meta.mainProgram}
  '';

  meta = previousAttrs.meta // {
    mainProgram = "clash-meta";
  };
})
