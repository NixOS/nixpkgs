{
  lib,
  flutter332,
  fetchFromGitHub,
  autoPatchelfHook,
<<<<<<< HEAD
  writeShellScript,
  nix-update,
  yq-go,
}:

let
  version = "1.2.2";
in
flutter332.buildFlutterApplication {
  pname = "proxypin";
  inherit version;
=======
}:

flutter332.buildFlutterApplication rec {
  pname = "proxypin";
  version = "1.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wanghongenpin";
    repo = "proxypin";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aMBUQkG/sZ7M9GzxKpO56MuGPRFLRGjrFpvsIUGDgkA=";
=======
    hash = "sha256-PRknUOCaaDE4Ri70EAROx1K3g2bLKI/HKIvo1W1D8ko=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

<<<<<<< HEAD
  gitHashes = lib.importJSON ./git-hashes.json;
=======
  gitHashes = {
    desktop_multi_window = "sha256-Tbl0DOxW1F8V2Kj34gcNRbBqr5t9Iq74qCT26deqFdQ=";
    flutter_code_editor = "sha256-B9aJh6e6iLBZAcacucsT9szWWBwWVBBPDhbKQfnxc6I=";
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postPatch = ''
    substituteInPlace linux/my_application.cc \
      --replace-fail "/opt/proxypin/data/flutter_assets/assets/icon.png" "$out/app/proxypin/data/flutter_assets/assets/icon.png"
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  postInstall = ''
    substituteInPlace linux/proxy-pin.desktop \
      --replace-fail "/opt/proxypin/data/flutter_assets/assets/icon.png" "proxypin" \
      --replace-fail "/opt/proxypin/" ""
<<<<<<< HEAD
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
    ${lib.getExe flutter332} pub get
    ${lib.getExe yq-go} eval --output-format=json --prettyPrint pubspec.lock > $PACKAGE_DIR/pubspec.lock.json
    popd
    $(nix eval --file . dart.fetchGitHashesScript) --input $PACKAGE_DIR/pubspec.lock.json --output $PACKAGE_DIR/git-hashes.json
  '';
=======
    install -Dm0644 linux/proxy-pin.desktop $out/share/applications/proxypin.desktop
    install -Dm0644 assets/icon.png $out/share/pixmaps/proxypin.png
  '';

  passthru.updateScript = ./update.sh;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Capture HTTP(S) traffic software";
    homepage = "https://github.com/wanghongenpin/proxypin";
    mainProgram = "ProxyPin";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
