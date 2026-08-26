{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  git,
  testers,
  d2,
  libdrm,
  libgbm,
  makeWrapper,
  playwright-driver,
  withImageSupport ? lib.meta.availableOn stdenv.hostPlatform libdrm,
}:

assert lib.assertMsg (
  withImageSupport -> lib.meta.availableOn stdenv.hostPlatform libdrm
) "d2: withImageSupport is not supported on ${stdenv.hostPlatform.system} (requires libdrm)";

buildGoModule (finalAttrs: {
  pname = "d2";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "d2lang";
    repo = "d2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4RYKm8wq+KxzLQbd3sIEZLTy7xBtlWhJCHfggvkktXo=";
  };

  vendorHash = "sha256-4IhAb3UeqSGX9jTdhWonf7lEBhUlUrrVt31NyfSoQF8=";

  excludedPackages = [ "./e2etests" ];

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # playwright-drivers.browsers pulls down ~2GB+ for Webkit, Chrome, Firefox etc
  buildInputs = lib.optionals withImageSupport [
    libgbm
    playwright-driver.browsers
  ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  ''
  # Wrap the d2 executable to set LD_LIBRARY_PATH for Playwright
  + lib.optionalString withImageSupport ''
    wrapProgram $out/bin/d2 \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
  '';

  preCheck = ''
    # See https://github.com/d2lang/d2/blob/master/docs/CONTRIBUTING.md#running-tests.
    export TESTDATA_ACCEPT=1
  '';

  passthru.tests.version = testers.testVersion {
    package = d2;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Modern diagram scripting language that turns text to diagrams";
    mainProgram = "d2";
    homepage = "https://d2lang.com";
    changelog = "https://github.com/d2lang/d2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
