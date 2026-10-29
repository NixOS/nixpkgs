{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "hut";
  version = "0.9.0";

  src = fetchFromSourcehut {
    owner = "~xenrox";
    repo = "hut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hruD8JNscS3h3f+QrU9n1OH9AyfnHsOb9M3JZkNYbSQ=";
  };

  vendorHash = "sha256-zb1+7D6+9kKsFUNtvtO+sXMNNRPHSs6tpWTjtnSsjhI=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  doInstallCheck = true;

  nativeBuildInputs = [
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  ldflags = [
    # Recommended in 0.7.0 release notes https://git.sr.ht/~xenrox/hut/refs/v0.7.0
    "-X main.version=${finalAttrs.version}"
  ];

  postBuild = ''
    make $makeFlags completions doc/hut.1
  '';

  preInstall = ''
    make $makeFlags install
  '';

  meta = {
    homepage = "https://sr.ht/~xenrox/hut/";
    description = "CLI tool for Sourcehut / sr.ht";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "hut";
  };
})
