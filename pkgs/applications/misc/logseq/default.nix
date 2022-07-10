{ lib, stdenv, fetchurl, appimageTools, makeWrapper, autoPatchelfHook, electron, git, curl, expat, gcc, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "logseq";
  version = "0.7.6";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
    sha256 = "sha256-3YCO0pQT5vUkscQEE4+XrfEkQJro8DpQ5xDLglfqJjI=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extract {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc curl expat openssl zlib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace Exec=Logseq Exec=${pname} \
      --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --prefix PATH : ${lib.makeBinPath [ git ]} \
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
