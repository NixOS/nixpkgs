{
  callPackage,
  fetchFromCodeberg,
  lib,
  libxcb,
  linux-pam,
  makeBinaryWrapper,
  nixosTests,
  stdenv,
  fetchpatch,
  versionCheckHook,
  x11Support ? true,
  zig_0_16,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.4.0";

  src = fetchFromCodeberg {
    owner = "fairyglade";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8wAt0gpIV97GY17B6rhjnhVR/UuuGQSAaKOcr+G1mKo=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig
  ];

  buildInputs = [
    linux-pam
  ]
  ++ lib.optionals x11Support [ libxcb ];

  patches = [
    (fetchpatch {
      name = "fix-building-without-x11";
      url = "https://codeberg.org/fairyglade/ly/commit/4db9295102ac43d054c4e12f067429c5104f6e19.patch";
      hash = "sha256-pzT1LkfbyVqYPaRsr/tEgtpt3lRj3i1ZlUm3+CTK21Q=";
    })
  ];

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
