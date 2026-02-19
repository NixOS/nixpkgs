{
  lib,
  flutter338,
  fetchFromGitHub,
  autoPatchelfHook,
  writeShellScript,
  nix-update,
  yq-go,
}:

let
  version = "1.2.4";
in
flutter338.buildFlutterApplication {
  pname = "proxypin";
  inherit version;

  src = fetchFromGitHub {
    owner = "wanghongenpin";
    repo = "proxypin";
    tag = "v${version}";
    hash = "sha256-Dhs2b+tjXTPFZOGoi7YUliWkdJ5s1jIJkJsXTQ6w7QY=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  postPatch = ''
    substituteInPlace linux/my_application.cc \
      --replace-fail "/opt/proxypin/data/flutter_assets/assets/icon.png" "$out/app/proxypin/data/flutter_assets/assets/icon.png"
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  postInstall = ''
    substituteInPlace linux/proxy-pin.desktop \
      --replace-fail "/opt/proxypin/data/flutter_assets/assets/icon.png" "proxypin" \
      --replace-fail "/opt/proxypin/" ""
    install -D --mode=0644 linux/proxy-pin.desktop $out/share/applications/proxypin.desktop
    install -D --mode=0644 assets/icon.png $out/share/icons/hicolor/256x256/apps/proxypin.png
  '';

  passthru.updateScript = writeShellScript "update-proxypin" ''
    ${lib.getExe nix-update} --use-github-releases proxypin
    export HOME=$(mktemp -d)
    src=$(nix build --no-link --print-out-paths .#proxypin.src)
    WORKDIR=$(mktemp -d)
    cp --recursive --no-preserve=mode $src/* $WORKDIR
    PACKAGE_DIR=$(dirname $(EDITOR=echo nix edit --file . proxypin))
    pushd $WORKDIR
    ${lib.getExe flutter338} pub get
    ${lib.getExe yq-go} eval --output-format=json --prettyPrint pubspec.lock > $PACKAGE_DIR/pubspec.lock.json
    popd
    $(nix eval --file . dart.fetchGitHashesScript) --input $PACKAGE_DIR/pubspec.lock.json --output $PACKAGE_DIR/git-hashes.json
  '';

  meta = {
    description = "Capture HTTP(S) traffic software";
    homepage = "https://github.com/wanghongenpin/proxypin";
    mainProgram = "ProxyPin";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
