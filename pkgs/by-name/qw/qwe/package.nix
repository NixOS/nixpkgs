{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "qwe";
  version = "0.3.3-a";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mainak55512";
    repo = "qwe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1M3b1ae28tvUwSSF8FsNMeYg3KpvcfK6jPc2EehTjR0=";
  };

  vendorHash = null;

  checkFlags = [
    # Stale since v0.3.3-a, which removes the stored object on untrack
    "-skip=^TestStopTracking$"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, flexible, file-first version/revision control system";
    longDescription = ''
      Qwe (pronounced kiwi) makes version control effortless.  Track
      individual files with precision, group them seamlessly, and
      commit or revert changes individually or together, all in one
      lightweight, intuitive tool built for speed and simplicity.
    '';
    homepage = "https://github.com/mainak55512/qwe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "qwe";
  };
})
