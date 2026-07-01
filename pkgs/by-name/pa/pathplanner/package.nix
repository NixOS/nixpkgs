{
  fetchFromGitHub,
  flutter335,
  lib,
  util-linux,
  xz,
}:

flutter335.buildFlutterApplication (finalAttrs: {
  pname = "pathplanner";
  version = "2026.1.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = "pathplanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ocqBviTfMxjdJdEu++yqUY9JTLs1qEnP94w6HCFp5f0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  buildInputs = [
    util-linux # For libblkid
    xz # For liblzma
  ];

  configurePhase = ''
    runHook postConfigure
  '';

  # Required for Pathplanner to load it's icon
  postPatch = ''
    substituteInPlace linux/my_application.cc \
    --replace-fail "images/icon.ico" "$out/app/pathplanner/data/flutter_assets/images/icon.ico"
  '';

  postInstall = ''
    install -Dm0644 $out/app/pathplanner/data/flutter_assets/images/icon.png $out/share/icons/hicolor/512x512/apps/pathplanner.png
  '';

  meta = {
    description = "FRC motion profile generator and path editor for robots";
    homepage = "https://github.com/mjansen4857/pathplanner";
    changelog = "https://github.com/mjansen4857/pathplanner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ colepearson27 ];
  };
})
