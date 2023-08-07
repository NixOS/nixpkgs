{ lib
, stdenv
, fetchurl
, appimageTools
, electron
, makeWrapper
, nix-update-script
}:

let
  version = "2.9.21";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Icalingua-plus-plus/Icalingua-plus-plus/releases/download/v${version}/Icalingua++-${version}.AppImage";
      sha256 = "1cy0nhc81c3w2ki0a2bb5bc67m4kwx0j06033328a83nqa3blv8r";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Icalingua-plus-plus/Icalingua-plus-plus/releases/download/v${version}/Icalingua++-${version}-arm64.AppImage";
      sha256 = "13b320srcim64faq87gknnwgp2kwllaxws41dq3swbkhkg2yqzn7";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "icalingua-plus-plus";
  inherit version src;

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/icalingua.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/Icalingua-plus-plus/Icalingua-plus-plus";
    description = "A client for QQ and more";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ rs0vere ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
