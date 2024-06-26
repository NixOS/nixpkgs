{ mkYarnPackage
, fetchFromGitHub
, electron_25
, wrapGAppsHook
, nix-update-script
, lib
}:

mkYarnPackage rec {
  pname = "sleek-todo";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "ransome1";
    repo = "sleek";
    rev = "v${version}";
    hash = "sha256-6jMJP09SjRSc0l51Dk1fCDQ7iq1rn4393VEvh/Oc9cM=";
  };

  packageJSONDir = src;

  nativeBuildInputs = [ wrapGAppsHook ];

  patches = [
    ./package.json.patch
    ./sleek.desktop.patch
  ];

  postPatch = ''
    #substituteInPlace src/scss/style.scss --replace '../../node_modules' $node_modules
    substituteInPlace package.json \
      --replace 'yarn' 'yarn --offline' \
      --replace 'electron-builder' 'electron-builder -c.electronDist=${electron_25}/lib/electron -c.electronVersion=${electron_25.version}'
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run dir

    runHook postBuild
  '';

  doCheck = false;
  checkPhase = ''
    runHook preCheck

    yarn --offline run test

    runHook postBuild
  '';

  /*installPhase = ''
    runHook preInstall

    mkdir -vp  $out/opt/sleek $out/share/{icons,applications}

    cp -r deps/sleek/dist/linux-unpacked/{locales,resources{,.pak}} $out/opt/sleek
    makeWrapper '${electron_25}/bin/electron' "$out/bin/sleek" \
      --add-flags $out/opt/sleek/resources/app.asar

    cp deps/sleek/snap/gui/sleek.desktop $out/share/applications/

    for icon in deps/sleek/assets/icons/*.png
    do
      basename=$(basename $icon)
      size=''${basename%.png}
      install -vD $icon $out/share/icons/hicolor/$size/apps/sleek.png
    done

    runHook postInstall
  '';*/

  installPhase = ''
    cd deps
    find .
  '';

  doDist = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/ransome1/sleek";
    description = "A GUI todo.txt manager";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
