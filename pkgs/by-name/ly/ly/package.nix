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
  zig_0_17,
  nix-update-script,
}:
let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.5.0";

  src = fetchFromCodeberg {
    owner = "fairyglade";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inrfs8c9ga1IJM1xm6KVxWpp2iubHSGpEM5s5hyJdcE=";
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
    hash = "sha256-ZaWJuJkQyx5eQlwOVmdz3BCrYddDNmKnP7QVYARSFp8=";
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
  nativeInstallCheckInputs = [ versionCheckHook ];

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
