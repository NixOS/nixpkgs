{
  lib,
  buildGoModule,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sigsum";
  version = "0.14.0";

  src = fetchFromGitLab {
    domain = "git.glasklar.is";
    group = "sigsum";
    owner = "core";
    repo = "sigsum-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+opDvVUG2OVJ/V1lHPXl2rxk4CCaXxc+4xBguvGqO1o=";
  };

  postPatch = ''
    substituteInPlace internal/version/version.go \
      --replace-fail "info.Main.Version" '"${finalAttrs.version}"'
  '';

  vendorHash = "sha256-s5IUDGA/8Qv6XhvqJG396EZt7HTaG/BMknPj8uYhVZc=";

  ldflags = [
    "-s"
    "-w"
  ];

  excludedPackages = [ "./test" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sigsum-key";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System for public and transparent logging of signed checksums";
    homepage = "https://www.sigsum.org/";
    downloadPage = "https://git.glasklar.is/sigsum/core/sigsum-go";
    changelog = "https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
