{ cwtch
, fetchgit
, flutter
, gnome
, lib
, tor
}:
let
  runtimeBinDependencies = [ tor gnome.zenity ];
in
flutter.buildFlutterApplication rec {
  pname = "cwtch-ui";
  version = "1.14.7";
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/cwtch-ui";
    rev = "v${version}";
    hash = "sha256-c02s8YFrLwIpvLVMM2d7Ynk02ibIgZmRKOI+mkrttLk=";
  };

  patches = [
    ./exhaustive-match.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.json;
  gitHashes = {
    flutter_gherkin = "sha256-NshzlM21x7jSFjP+M0N4S7aV3BcORkZPvzNDwJxuVSA=";
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
    sed "s|PREFIX|$out|" linux/cwtch.template.desktop >$out/share/applications/cwtch.desktop
  '';

  meta = {
    description = "A decentralized, privacy-preserving, multi-party messaging app";
    homepage = "https://cwtch.im/";
    changelog = "https://cwtch.im/changelog/";
    license = lib.licenses.mit;
    mainProgram = "cwtch";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
    maintainers = [ lib.maintainers.gmacon ];
  };
}
