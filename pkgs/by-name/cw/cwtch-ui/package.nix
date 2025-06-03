{
  cwtch,
  fetchgit,
  flutter329,
  lib,
  tor,
}:
let
  runtimeBinDependencies = [
    tor
  ];
in
flutter329.buildFlutterApplication rec {
  pname = "cwtch-ui";
  version = "1.15.5";
  # This Gitea instance has archive downloads disabled, so: fetchgit
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/cwtch-ui";
    rev = "v${version}";
    hash = "sha256-u0IFLZp53Fg8soKjSXr6IjNxFI9aTU5xUYgf1SN6rTQ=";
  };

  # NOTE: The included pubspec.json does not exactly match the upstream
  # pubspec.lock. With Flutter 3.24, a newer version of material_color_utilities
  # is required than the upstream locked version. From a checkout of cwtch-ui
  # 1.15.4, I ran `flutter pub upgrade material_color_utilities` on 2024-12-15.
  # This upgraded material_color_utilities and its dependencies.
  pubspecLock = lib.importJSON ./pubspec.json;
  gitHashes = {
    flutter_gherkin = "sha256-Y8tR84kkczQPBwh7cGhPFAAqrMZKRfGp/02huPaaQZg=";
  };

  flutterBuildFlags = [
    "--dart-define"
    "BUILD_VER=${version}"
    "--dart-define"
    "BUILD_DATE=1980-01-01-00:00"
  ];

  # These things are added to LD_LIBRARY_PATH, but not PATH
  runtimeDependencies = [ cwtch ];

  extraWrapProgramArgs = "--prefix PATH : ${lib.makeBinPath runtimeBinDependencies}";

  postInstall = ''
    mkdir -p $out/share/applications
    substitute linux/cwtch.template.desktop "$out/share/applications/cwtch.desktop" \
      --replace-fail PREFIX "$out"
  '';

  meta = {
    description = "Messaging app built on the cwtch decentralized, privacy-preserving, multi-party messaging protocol";
    homepage = "https://cwtch.im/";
    changelog = "https://docs.cwtch.im/changelog";
    license = lib.licenses.mit;
    mainProgram = "cwtch";
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.gmacon ];
  };
}
