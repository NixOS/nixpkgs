{ mkYarnPackage
, fetchFromGitHub
, electron_18
, wrapGAppsHook
, nix-update-script
, lib
}:

mkYarnPackage rec {
  pname = "sleek";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ransome1";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j5T4StCcHtNHEn0VycPJlX/w+F0jZYBPEgHI/n5nGiI=";
  };

  packageJSONDir = src;

  nativeBuildInputs = [ wrapGAppsHook ];

  patches = [
    ./package.json.patch
    ./sleek.desktop.patch
  ];

  postPatch = ''
    substituteInPlace src/scss/style.scss --replace '../../node_modules' $node_modules
    substituteInPlace package.json \
      --replace 'yarn' 'yarn --offline' \
      --replace 'electron-builder' 'electron-builder -c.electronDist=${electron_18}/lib/electron -c.electronVersion=${electron_18.version}'
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build:linux

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    pushd deps/sleek

    yarn --offline test
    yarn --offline test1

    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -vp  $out/opt/sleek $out/share/{icons,applications}

    cp -r deps/sleek/dist/linux-unpacked/{locales,resources{,.pak}} $out/opt/sleek
    makeWrapper '${electron_18}/bin/electron' "$out/bin/sleek" \
      --add-flags $out/opt/sleek/resources/app.asar

    cp deps/sleek/snap/gui/sleek.desktop $out/share/applications/

    for icon in deps/sleek/assets/icons/*.png
    do
      basename=$(basename $icon)
      size=''${basename%.png}
      install -vD $icon $out/share/icons/hicolor/$size/apps/sleek.png
    done

    runHook postInstall
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
