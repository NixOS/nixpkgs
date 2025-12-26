{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  versionCheckHook,
  nix-update-script,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prctl";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "hikerockies";
    repo = "prctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1b8SO70mp0ACL3hw/iwKpPUpI5G7hF7l84hlSDHB2oA=";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  patches = [
    # Eliminate unsafe strcpy() calls,
    # cf. <https://github.com/hikerockies/prctl/pull/1>
    ./prctl-strcpy-overflow.patch

    # Correct option parsing,
    # cf. <https://github.com/hikerockies/prctl/pull/2>
    ./prctl-getopt.patch
  ];

  postPatch = ''
    substituteInPlace prctl.c \
      --replace-fail '"/bin/bash"' '"${lib.getExe bash}"'
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to query and modify process behaviour";
    homepage = "https://tracker.debian.org/pkg/prctl";
    changelog = "https://github.com/hikerockies/prctl/blob/v${finalAttrs.version}/ChangeLog";
    mainProgram = "prctl";
    maintainers = with lib.maintainers; [ mvs ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
