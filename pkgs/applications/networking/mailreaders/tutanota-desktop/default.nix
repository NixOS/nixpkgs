{ stdenv, lib, fetchurl, makeDesktopItem, copyDesktopItems, makeWrapper,
electron, libsecret }:

stdenv.mkDerivation rec {
  pname = "tutanota-desktop";
  version = "3.119.3";

  src = fetchurl {
    url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/${pname}-${version}-unpacked-linux.tar.gz";
    name = "tutanota-desktop-${version}.tar.gz";
    hash = "sha256-TdjvU12nh1sTfGTdBn+7dbEunaF38YjDvceEns4iRbA=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "tutanota-desktop";
    icon = "tutanota-desktop";
    comment = meta.description;
    desktopName = "Tutanota Desktop";
    genericName = "Email Reader";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/tutanota-desktop $out/share/tutanota-desktop

    cp -r ./ $out/opt/tutanota-desktop
    mv $out/opt/tutanota-desktop/{locales,resources} $out/share/tutanota-desktop

    for icon_size in 64 512; do
      icon=resources/icons/icon/$icon_size.png
      path=$out/share/icons/hicolor/$icon_size'x'$icon_size/apps/tutanota-desktop.png
      install -Dm644 $icon $path
    done

    makeWrapper ${electron}/bin/electron \
      $out/bin/tutanota-desktop \
      --add-flags $out/share/tutanota-desktop/resources/app.asar \
      --run "mkdir -p /tmp/tutanota" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret stdenv.cc.cc.lib ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tutanota official desktop client";
    homepage = "https://tutanota.com/";
    changelog = "https://github.com/tutao/tutanota/releases/tag/tutanota-desktop-release-${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "tutanota-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
