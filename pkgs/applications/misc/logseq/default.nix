{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron, git }:

stdenv.mkDerivation rec {
  pname = "logseq";
  version = "0.7.9";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
    sha256 = "sha256-tca9jWMlBT+r1CFyGKe8xMA6O0T/tnbmU7uVk+3o87o=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extract {
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
    cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop

    # remove the `git` in `dugite` because we want the `git` in `nixpkgs`
    chmod +w -R $out/share/${pname}/resources/app/node_modules/dugite/git
    chmod +w $out/share/${pname}/resources/app/node_modules/dugite
    rm -rf $out/share/${pname}/resources/app/node_modules/dugite/git
    chmod -w $out/share/${pname}/resources/app/node_modules/dugite

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace Exec=Logseq Exec=${pname} \
      --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png

    runHook postInstall
  '';

  postFixup = ''
    # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --set "LOCAL_GIT_DIRECTORY" ${git} \
      --add-flags $out/share/${pname}/resources/app
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ weihua ];
    platforms = [ "x86_64-linux" ];
  };
}
