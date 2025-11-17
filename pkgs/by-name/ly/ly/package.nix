{
  stdenv,
  lib,
  fetchFromGitea,
  linux-pam,
  libxcb,
  makeBinaryWrapper,
  zig_0_15,
  callPackage,
  nixosTests,
  x11Support ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fairyglade";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2JOpC70uBvGk17edXDNeNhNqn2hHZBpOoQaUxN0IlLk=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig_0_15.hook
  ];
  buildInputs = [
    linux-pam
  ]
  ++ (lib.optionals x11Support [ libxcb ]);

  postPatch = ''
    ln -s ${
      callPackage ./deps.nix {
        zig = zig_0_15;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';
  zigBuildFlags = [
    "-Denable_x11_support=${lib.boolToString x11Support}"
  ];

  passthru.tests = { inherit (nixosTests) ly; };

  meta = {
    description = "TUI display manager";
    license = lib.licenses.wtfpl;
    homepage = "https://codeberg.org/fairyglade/ly";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "ly";
  };
})
