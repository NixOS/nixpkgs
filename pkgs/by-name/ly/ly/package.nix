{
  callPackage,
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
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.4.1";

  src = fetchFromCodeberg {
    owner = "fairyglade";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FiHSUqAxJurlQuXEkpglWrd2tCqKZuucB4mipFGI4II=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig
  ];

  buildInputs = [
    linux-pam
  ]
  ++ lib.optionals x11Support [ libxcb ];

  zigBuildFlags = [
    "--system"
    "${callPackage ./deps.nix { }}"
    "-Denable_x11_support=${lib.boolToString x11Support}"
  ];

  postInstall = ''
    install -Dm0644 res/config.ini "$out/etc/config.ini"
    install -Dm0755 res/setup.sh "$out/etc/setup.sh"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests = { inherit (nixosTests) ly; };

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
