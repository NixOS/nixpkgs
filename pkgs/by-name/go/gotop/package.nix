{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gotop";
  version = "4.2.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = "gotop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W7a3QnSIR95N88RqU2sr6oEDSqOXVfAwacPvS219+1Y=";
  };

  proxyVendor = true;
  vendorHash = "sha256-KLeVSrPDS1lKsKFemRmgxT6Pxack3X3B/btSCOUSUFY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  postInstall = ''
    $out/bin/gotop --create-manpage > gotop.1
    installManPage gotop.1
  '';

  meta = {
    description = "Terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.magnetophon ];
    mainProgram = "gotop";
  };
})
