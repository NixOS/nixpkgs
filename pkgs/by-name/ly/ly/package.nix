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
  zig_0_15,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.3.1";

  src = fetchFromCodeberg {
    owner = "fairyglade";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BelsR/+sfm3qdEnyf4bbadyzuUVvVPrPEhdZaNPLxiE=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig
  ];

  buildInputs = [
    linux-pam
  ]
  ++ (lib.optionals x11Support [ libxcb ]);

  postConfigure = ''
    ln -s ${
      callPackage ./deps.nix {
        inherit zig;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

  zigBuildFlags = [
    "-Denable_x11_support=${lib.boolToString x11Support}"
  ];

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
