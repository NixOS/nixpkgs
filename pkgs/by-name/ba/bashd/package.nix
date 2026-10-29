{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  shellcheck,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bashd";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "matkrin";
    repo = "bashd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pnN5K4fxnxmsYJDw3ieHgmqpxzUDuWnmttwio3q/UPs=";
  };

  vendorHash = "sha256-B4szacVckxUeF0xndHX3T6FnGTF0BkGo9k8uZUWURVM=";

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  ldflags = [
    "-X main.VERSION=${finalAttrs.version}"
  ];

  preFixup = ''
    wrapProgram "$out/bin/bashd" --prefix PATH : ${lib.makeBinPath [ shellcheck ]}
  '';

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/matkrin/bashd";
    description = "Bash language server";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ supermarin ];
    mainProgram = "bashd";
  };
})
