{
  buildNpmPackage,
  open5gs,
}:

buildNpmPackage (finalAttrs: {
  pname = "${open5gs.pname}-webui";
  inherit (open5gs) src version meta;

  sourceRoot = "${finalAttrs.src.name}/webui";

  npmDepsHash = "sha256-IpqineYa15GBqoPDJ7RpaDsq+MQIIDcdq7yhwmH4Lzo=";
})
