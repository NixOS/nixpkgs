{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  jujutsu,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blazingjj";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "blazingjj";
    repo = "blazingjj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vefD93gzT6WEplpnYiENtzXLSeXBo+9K3/RYpSBafDs=";
  };

  cargoHash = "sha256-E/xddxdvCDWH1xPn/CPXFyJIHg1Dy6EG3VZMZouWHQY=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  nativeCheckInputs = [
    jujutsu
  ];

  postInstall = ''
    wrapProgram $out/bin/blazingjj \
      --prefix PATH : ${lib.makeBinPath [ jujutsu ]}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  checkFlags = [
    # This tests checks the output of `jj diff`. However, `jj diff` had a change upstream making the test fail. Skip for now, until the test is updated.
    "--skip=commander::files::tests::get_file_diff"
  ];

  __structuredAttrs = true;

  meta = {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/blazingjj/blazingjj";
    changelog = "https://github.com/blazingjj/blazingjj/releases/tag/v${finalAttrs.version}";
    mainProgram = "blazingjj";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      peret
    ];
  };
})
