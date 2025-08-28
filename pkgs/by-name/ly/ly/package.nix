{
  stdenv,
  lib,
  fetchFromGitea,
  linux-pam,
  libxcb,
  makeBinaryWrapper,
  zig_0_14,
  nixosTests,
  x11Support ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "AnErrupTion";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xD1FLW8LT+6szfjZbP++qJThf4xxbmw4jRHB8TdrG70=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig_0_14.hook
  ];
  buildInputs = [
    linux-pam
  ]
  ++ (lib.optionals x11Support [ libxcb ]);

  zigDeps = zig_0_14.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-eVV9IOqSj9nZ05il2qN7A2RiXa/6rq6I5n5p5pC8EkE=";
  };

  zigBuildFlags = [
    "-Denable_x11_support=${lib.boolToString x11Support}"
  ];

  passthru.tests = { inherit (nixosTests) ly; };

  meta = {
    description = "TUI display manager";
    license = lib.licenses.wtfpl;
    homepage = "https://codeberg.org/AnErrupTion/ly";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "ly";
  };
})
