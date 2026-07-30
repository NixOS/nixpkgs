{
  buildGoModule,
  headplane,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "headplane-agent";
  __structuredAttrs = true;
  inherit (headplane) version src;

  vendorHash = headplane.goVendorHash;

  subPackages = [ "cmd/hp_agent" ];

  ldflags = [
    "-s"
    "-w"
  ];
  env.CGO_ENABLED = 0;

  meta = {
    description = "Optional sidecar process providing additional features for headplane";
    homepage = "https://github.com/tale/headplane";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      igor-ramazanov
      stealthbadger747
    ];
    mainProgram = "hp_agent";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
