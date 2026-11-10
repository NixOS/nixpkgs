{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "modctl";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "modelpack";
    repo = "modctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A7s2jM+hR5WgeiWzPjjfS/AJy35x6kzewIucz713zLc=";
  };

  vendorHash = "sha256-S1ygAZO3bTFi/3pwmNYE7P/Vqg7AVHpH5YRJ3yzzvyo=";

  ldflags = [
    "-s"
    "-X github.com/modelpack/modctl/pkg/version.GitVersion=v${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  # modctl's cobra commands invoke config.NewRoot(), which uses
  # os/user.Current() to find the home directory. On darwin os/user
  # bypasses $HOME and resolves it via getpwuid (returning /var/empty,
  # not writable), so the install check fails. versionCheckHook only
  # accepts a single argument, so wrap the binary and point
  # --log-dir/--storage-dir at TMPDIR to keep the check working on all
  # platforms.
  preVersionCheck = ''
    wrapper="$NIX_BUILD_TOP/modctl-version-check"
    cat > "$wrapper" <<EOF
    #!/bin/sh
    exec "$out/bin/modctl" "\$@" --log-dir="$TMPDIR" --storage-dir="$TMPDIR"
    EOF
    chmod +x "$wrapper"
    versionCheckProgram="$wrapper"
  '';

  meta = {
    description = "CLI tool for managing OCI model artifacts based on Model Spec";
    homepage = "https://github.com/modelpack/modctl";
    changelog = "https://github.com/modelpack/modctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gbhu753 ];
    mainProgram = "modctl";
  };
})
