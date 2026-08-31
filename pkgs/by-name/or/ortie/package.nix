{
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  buildPackages,
  dbus,
  fetchFromGitHub,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellFiles,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  nativeTls = builtins.elem "native-tls" buildFeatures;
  notify = builtins.elem "notify" buildFeatures;

  # dbus calls libgcc outline atomics that the static aarch64 link cannot
  # resolve (__aarch64_ldset4_sync & co), so inline them instead.
  dbus' =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64 then
      dbus.overrideAttrs (old: {
        env = (old.env or { }) // {
          NIX_CFLAGS_COMPILE = (old.env.NIX_CFLAGS_COMPILE or "") + " -mno-outline-atomics";
        };
      })
    else
      dbus;

in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  inherit buildNoDefaultFeatures;

  pname = "ortie";
  version = "2.1.0";
  cargoHash = "sha256-ZAW+Coyv1DVmF2HWr7CmFMtQT9hNaS+1koWoZCJ+Wsc=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-5KRXPIDYBfF/2fNnrJur8WdfLYvgtJWlTWA7YD8yYWg=";
  };

  env = {
    # pkg-config hands the linker libdbus but no rpath, leaving a binary that
    # cannot find it: not in postInstall, which runs it, nor once installed.
    NIX_LDFLAGS = lib.optionalString (notify && !stdenv.hostPlatform.isWindows) (
      "-rpath " + lib.getLib dbus' + "/lib"
    );

    # openssl should not be provided by vendors, not even on windows
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    lib.optional nativeTls openssl
    # dbus is provided by vendors on windows
    ++ lib.optional (notify && !stdenv.hostPlatform.isWindows) dbus';

  buildFeatures =
    buildFeatures
    # dbus is provided by vendors on windows
    ++ lib.optional (notify && stdenv.hostPlatform.isWindows) "vendored";

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/${finalAttrs.pname}"
        else
          lib.getExe buildPackages.${finalAttrs.pname};
    in
    ''
      mkdir -p $out/share/{completions,man}
      ${exe} manuals "$out"/share/man
      ${exe} completions -d "$out"/share/completions bash elvish fish powershell zsh
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd ${finalAttrs.pname} \
        --bash "$out"/share/completions/${finalAttrs.pname}.bash \
        --fish "$out"/share/completions/${finalAttrs.pname}.fish \
        --zsh "$out"/share/completions/_${finalAttrs.pname}
    '';

  # disable impure integration tests
  cargoTestFlags = [ "--bins" ];

  meta = {
    description = "CLI to manage OAuth 2.0 tokens";
    mainProgram = finalAttrs.pname;
    homepage = "https://github.com/pimalaya/${finalAttrs.pname}";
    changelog = "https://github.com/pimalaya/${finalAttrs.pname}/releases/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      soywod
      bobberb
    ];
  };
})
