{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crlite-create-cascade";
  version = "1.0.44";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "crlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GQUxYa7bQEyWJmtDIgwuaw/AXcGr3L420vsHu9MgqwU=";
  };

  cargoHash = "sha256-uwFltlmbDT/egxqtbJft5+ql/SoUnba0XJSib+DbsBg=";

  sourceRoot = "${finalAttrs.src.name}/rust-create-cascade";

  postInstall = ''
    mv $out/bin/{rust,crlite}-create-cascade
    mv $out/bin/{,crlite-}transcode-clubcard
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/crlite-create-cascade --help > /dev/null
    $out/bin/crlite-transcode-clubcard --help > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Tool for building CRLite certificate revocation filters";
    homepage = "https://github.com/mozilla/crlite";
    changelog = "https://github.com/mozilla/crlite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = [
      lib.maintainers.skyesoss
      lib.maintainers.cpu
    ];
    mainProgram = "crlite-create-cascade";
  };
})
