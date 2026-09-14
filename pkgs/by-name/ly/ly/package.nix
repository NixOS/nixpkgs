{
  fetchFromCodeberg,
  lib,
  libxcb,
  linux-pam,
  makeBinaryWrapper,
  nixosTests,
  stdenv,
  versionCheckHook,
  x11Support ? true,
  zig_0_16,
  nix-update-script,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ly";

  # TODO(leana8959): bump version to 1.5
  version = "1.5.0-rc1";

  src = fetchFromCodeberg {
    owner = "fairyglade";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DerU/tGSqPm0RKV/Tu7ZizxXiyvNyTFUjRDUZkIRONU=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig
  ];

  buildInputs = [
    linux-pam
  ]
  ++ lib.optionals x11Support [ libxcb ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-rBr6Zu3mUWSOdscrHh3yW54H6ap0LCV0t0KuUgUbH5s=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  zigBuildFlags = [ "-Denable_x11_support=${lib.boolToString x11Support}" ];

  postInstall = ''
    install -Dm0644 res/config.ini "$out/etc/config.ini"
    install -Dm0755 res/setup.sh "$out/etc/setup.sh"
  '';

  doInstallCheck = true;
  # nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    tests = { inherit (nixosTests) ly; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI display manager";
    longDescription = ''
      Ly is a lightweight TUI (ncurses-like) display manager for Linux
      and BSD, designed with portability in mind (e.g. it does not
      require systemd to run).
    '';
    homepage = "https://codeberg.org/fairyglade/ly";
    license = lib.licenses.wtfpl;
    mainProgram = "ly";
    maintainers = with lib.maintainers; [
      zacharyarnaise
    ];
    platforms = lib.platforms.unix;
  };
})
