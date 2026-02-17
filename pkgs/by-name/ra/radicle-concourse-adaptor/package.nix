{
  lib,
  buildGoModule,
  fetchgit,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "radicle-concourse-adapter";
  version = "0.6.6";

  src = fetchgit {
    url = "https://seed.radicle.garden/z2woyw9Get9Q21VJzdbVz33b47xDb.git";
    rev = "525e19167448f07fb87d9720c07b832a38332f5a";
    hash = "sha256-sEMIKOC+/iXpxJspgH85pVGcfwyTVhZUioy2pgaeSuw=";
  };

  vendorHash = "sha256-IJzYLR9FVU/+00WbRSVIBUhGVAuNtkEIA3cjW7CGex8=";

  subPackages = [ "cmd/concourse-adapter" ];

  ldflags = [
    "-s"
    "-w"
    "-X radicle-concourse-adapter/pkg/version.Version=${finalAttrs.version}"
    "-X radicle-concourse-adapter/pkg/version.BuildTime=1970-01-01"
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    gitMinimal
  ];

  postInstall = ''
    mv $out/bin/concourse-adapter $out/bin/radicle-concourse-adapter
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "A Concourse CI adapter for Radicle Broker";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.garden/rad:z2woyw9Get9Q21VJzdbVz33b47xDb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "radicle-concourse-adapter";
  };
})
