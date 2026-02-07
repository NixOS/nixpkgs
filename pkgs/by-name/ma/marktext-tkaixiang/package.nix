{ lib
, buildNpmPackage
, fetchFromGitHub
, makeDesktopItem
, electron
, makeWrapper
, nodejs_22
, libsecret
, pkg-config
, xorg
, libxkbfile
}:
let
  desktopItem = makeDesktopItem {
    name = "marktext";
    desktopName = "MarkText (Tkaixiang fork)";
    exec = "marktext %U";
    icon = "marktext";
    terminal = false;
    categories = [
      "Office"
      "TextEditor"
      "Utility"
    ];
  };
in
buildNpmPackage rec {
  pname = "marktext";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "Tkaixiang";
    repo = "marktext";
    rev = "v${version}";
    hash = "sha256-JWGwW5+BtXPPr3DhXSlPNUCGUY2UJnTuRlOLvG2QpD0=";
  };

  npmDepsHash = "sha256-AwmnvCSIA6+5QShGQmngu01MS5NXbR0b18N5ocEfdqI=";

  makeCacheWritable = true;
  npmInstallFlags = [ "--ignore-scripts" ];
  npmRebuildFlags = [ "--ignore-scripts" ];
  nodejs = nodejs_22;

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  ELECTRON_OVERRIDE_DIST_PATH = "${electron}/libexec/electron";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    nodejs_22.pkgs.asar
  ];

  buildInputs = [
    libsecret
    xorg.libX11
    libxkbfile
  ];

# Package lock in repo doesn't work
  postPatch = ''
      rm package-lock.json
      cp ${./package-lock.json} package-lock.json
    '';

  buildPhase = ''
    npm run build:linux -- --linux --dir \
      --config.electronDist=${electron}/libexec/electron \
      --config.electronVersion=${electron.version}
  '';

installPhase = ''
  mkdir -p $out/lib/marktext
  cp -r dist/linux-unpacked/* $out/lib/marktext/

# Patch the process.resourcesPath
  asar extract $out/lib/marktext/resources/app.asar patched-asar
  sed -i \
    "s#process\\.resourcesPath#'$out/lib/marktext/resources'#g" \
    patched-asar/out/main/index.js
  asar pack patched-asar $out/lib/marktext/resources/app.asar

  mkdir -p $out/bin
  makeWrapper ${electron}/bin/electron $out/bin/marktext \
    --add-flags "--app=$out/lib/marktext/resources/app.asar"\
    --chdir $out/lib/marktext/resources \

    install -Dm444 \
        ${desktopItem}/share/applications/*.desktop \
        $out/share/applications/marktext.desktop
'';

    meta = with lib; {
    description = "Modern Markdown Editor (fork by tkaixiang)";
    homepage = "https://github.com/Tkaixiang/marktext";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "marktext";
  };
}

