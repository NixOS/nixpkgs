{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "keep-sorted";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "keep-sorted";
    tag = "v${version}";
    hash = "sha256-ROvj7w8YMq6+ntx0SWi+HfN4sO6d7RjKWwlb/9gfz8w=";
  };

  vendorHash = "sha256-HTE9vfjRmi5GpMue7lUfd0jmssPgSOljbfPbya4uGsc=";

  # Inject version string instead of reading version from buildinfo.
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail 'readVersion())' '"v${version}")'
  '';

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  preCheck = ''
    # Test tries to find files using git in init func.
    rm goldens/*_test.go
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/google/keep-sorted/releases/tag/v${version}";
    description = "Language-agnostic formatter that sorts lines between two markers in a larger file";
    homepage = "https://github.com/google/keep-sorted";
    license = lib.licenses.asl20;
    mainProgram = "keep-sorted";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
