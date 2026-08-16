{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  sq,
}:

buildGoModule (finalAttrs: {
  pname = "sq";
  version = "0.54.1";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = "sq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k5BoJGEgLE2GZYOjK5DvI0uRo2++X76SpdTo1Nzyc90=";
  };

  vendorHash = "sha256-XrgM+qe9BWRsbsBUydy6IAjbqHgKHL0TLy55KhS8lx0=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Version=v${finalAttrs.version}"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Commit=${finalAttrs.src.rev}"
    "-X=github.com/neilotoole/sq/cli/buildinfo.Timestamp=1970-01-01T00:00:00Z"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for sh in bash fish zsh; do
      installShellCompletion --cmd sq --$sh <($out/bin/sq completion $sh)
    done
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = sq;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Swiss army knife for data";
    homepage = "https://sq.io/";
    changelog = "https://github.com/neilotoole/sq/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "sq";
  };
})
