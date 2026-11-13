{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libpng,
  nix-update-script,
  perl,
  pkg-config,
  rgbds,
  versionCheckHook,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sameboy";
  version = "1.0.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "LIJI32";
    repo = "SameBoy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yz/rNoviuM8uFI53TABf+RqGk0M47GMN9MkhIpwajE8=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace SDL/open_dialog/gtk.c \
      --replace-fail '"libgtk-3.so"' '"${lib.getLib gtk3}/lib/libgtk-3.so"'
  '';

  nativeBuildInputs = [
    rgbds
  ]
  # glib and wrapGAppsHook3 are needed to make the Open ROM menu work.
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    glib
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # The Makefile doesn't use pkg-config on macOS; it asks sdl2-config instead.
    SDL2
  ];

  buildInputs = [
    SDL2
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libpng
    gdk-pixbuf
    glib
  ];

  makeFlags = [
    "CONF=release"
    # Also sets DATA_DIR, where Sameboy finds shaders/palettes/boot roms
    "FREEDESKTOP=true"
    "PREFIX=${placeholder "out"}"
    "DESTDIR=/"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # The Makefile looks for the SDK through xcodebuild or the Command Line Tools.
    "SYSROOT=$(SDKROOT)"
    # Leave stripping and ad-hoc signing to stdenv.
    "STRIP=true"
    "CODESIGN=true"
  ];

  # The default macOS target is the Xcode-only Cocoa app, and the install
  # target needs the Linux-only thumbnailer, so build the SDL frontend only.
  buildFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "sdl" ];

  doCheck = true;
  nativeCheckInputs = [ perl ];
  postCheck = "sh .github/actions/sanity_tests.sh";

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    install -Dm755 build/bin/SDL/sameboy $out/bin/sameboy
    (cd build/bin/SDL && find . ! -name sameboy -type f -exec install -Dm644 {} $out/share/sameboy/{} \;)

    runHook postInstall
  '';

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace $out/share/thumbnailers/sameboy.thumbnailer \
      --replace-fail "TryExec=sameboy-thumbnailer" "TryExec=$out/bin/sameboy-thumbnailer" \
      --replace-fail "Exec=sameboy-thumbnailer" "Exec=$out/bin/sameboy-thumbnailer"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  checkTarget = "tester";
  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script {
    # Skip the -libretro and -appstore tags
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Game Boy, Game Boy Color, and Super Game Boy emulator";
    longDescription = ''
      SameBoy is a user friendly Game Boy, Game Boy Color and Super
      Game Boy emulator for macOS, Windows and Unix-like platforms.
      SameBoy is extremely accurate and includes a wide range of
      powerful debugging features, making it ideal for both casual
      players and developers. In addition to accuracy and developer
      capabilities, SameBoy has all the features one would expect from
      an emulator – from save states to scaling filters.
    '';
    homepage = "https://sameboy.github.io";
    changelog = "https://github.com/LIJI32/SameBoy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NieDzejkob ];
    platforms = lib.platforms.unix;
    mainProgram = "sameboy";
  };
})
