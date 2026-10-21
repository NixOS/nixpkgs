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

  postPatch = ''
    substituteInPlace SDL/open_dialog/gtk.c \
      --replace-fail '"libgtk-3.so"' '"${lib.getLib gtk3}/lib/libgtk-3.so"'
  '';

  nativeBuildInputs = [
    glib
    pkg-config
    rgbds
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    libGL
    libpng
    gdk-pixbuf
    glib
  ];

  makeFlags = [
    "CONF=release"
    "FREEDESKTOP=true"
    "PREFIX=${placeholder "out"}"
    "DESTDIR=/"
  ];

  doCheck = true;
  nativeCheckInputs = [ perl ];
  postCheck = "sh .github/actions/sanity_tests.sh";

  postInstall = ''
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
    platforms = lib.platforms.linux;
    mainProgram = "sameboy";
  };
})
