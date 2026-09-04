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
  pkg-config,
  rustPlatform,
  stdenv,
  withTcp ? null,
}:

let
  notify = !buildNoDefaultFeatures || builtins.elem "notify" buildFeatures;

  buildFeatures' = lib.warnIf (
    withTcp != null
  ) "comodoro withTcp is obsolete: TCP is always available since v2" buildFeatures;

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

  pname = "comodoro";
  version = "2.0.0";
  cargoHash = "sha256-GA1Snf7EEM5ue6HE1QquW0xXu/qwdhQITqBDjOP9+zk=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-W/ZTgQ7JsVOjkbK8JjoTf154v5RTnQZ5d6AAlL/RTNs=";
  };

  # pkg-config hands the linker libdbus but no rpath, leaving a binary that
  # cannot find it: not in postInstall, which runs it, nor once installed.
  env.NIX_LDFLAGS = lib.optionalString (notify && !stdenv.hostPlatform.isWindows) (
    "-rpath " + lib.getLib dbus' + "/lib"
  );

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  # dbus is provided by vendors on windows
  buildInputs = lib.optional (notify && !stdenv.hostPlatform.isWindows) dbus';

  buildFeatures =
    buildFeatures'
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
      mkdir -p $out/share/{completions,man,schemas}
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} manual "$out"/share/man
      ${exe} json-schema "$out"/share/schemas
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

  # disable impure integration tests: they bind sockets and spawn processes
  cargoTestFlags = [
    "--bins"
    "--lib"
  ];

  meta = {
    description = "CLI to manage timers";
    mainProgram = finalAttrs.pname;
    homepage = "https://github.com/pimalaya/${finalAttrs.pname}";
    changelog = "https://github.com/pimalaya/${finalAttrs.pname}/releases/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ soywod ];
  };
})
