{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "snitch";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "karol-broda";
    repo = "snitch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SssAiRUfUaDgAoVO2rDacru8e914Wl+4sA4JQ4Mv4eA=";
  };

  vendorHash = "sha256-fX3wOqeOgjH7AuWGxPQxJ+wbhp240CW8tiF4rVUUDzk=";

  postPatch = ''
    substituteInPlace cmd/version.go \
      --replace-fail \
        'Version = "dev"' \
        'Version = "${finalAttrs.version}"'
  '';

  # these below settings (env, buildInputs, ldflags) copied from
  # https://github.com/karol-broda/snitch/blob/master/flake.nix

  env = {
    # darwin requires cgo for libproc, linux uses pure go with /proc
    CGO_ENABLED = if stdenv.hostPlatform.isDarwin then 1 else 0;
  };

  ldflags = [
    "-s"
    "-X snitch/cmd.Version=${finalAttrs.version}"
    "-X snitch/cmd.Commit=v${finalAttrs.version}"
    "-X snitch/cmd.Date=1970-01-01"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "friendlier ss / netstat for humans";
    homepage = "https://github.com/karol-broda/snitch";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.DieracDelta ];
    platforms = lib.platforms.unix;
    mainProgram = "snitch";
  };
})
