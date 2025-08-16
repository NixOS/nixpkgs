{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ferretdb";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SKgn8FGf6qHzuVLCHjkcjSPYvWttV4imALJgnClAmWY=";
  };

  postPatch = ''
    echo v${finalAttrs.version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

  vendorHash = "sha256-fVyjCJmXEtGWnZSWILXaEpVFzzRW64tczTunKm4d4y8=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  # tests in cmd/ferretdb are not production relevant
  doCheck = false;

  # the binary panics if something required wasn't set during compilation
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.tests = nixosTests.ferretdb;

  meta = {
    description = "Truly Open Source MongoDB alternative";
    mainProgram = "ferretdb";
    changelog = "https://github.com/FerretDB/FerretDB/releases/tag/v${finalAttrs.version}";
    homepage = "https://www.ferretdb.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dit7ya
      noisersup
      julienmalka
    ];
  };
})
