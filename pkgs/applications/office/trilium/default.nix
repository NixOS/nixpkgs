{ stdenv, fetchurl, p7zip, autoPatchelfHook, atomEnv, makeWrapper, makeDesktopItem }:

let
  description = "Trilium Notes is a hierarchical note taking application with focus on building large personal knowledge bases.";
  desktopItem = makeDesktopItem {
    name = "Trilium";
    exec = "trilium";
    icon = "trilium";
    comment = description;
    desktopName = "Trilium Notes";
    categories = "Office";
  };

in stdenv.mkDerivation rec {
  name = "trilium-${version}";
  version = "0.27.4";

  src = fetchurl {
    url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.7z";
    sha256 = "1qb11axaifw5xjycrc6qsyd8h36rgjd7rjql8895v8agckf3g2c1";
  };

  nativeBuildInputs = [
    p7zip /* for unpacking */
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = atomEnv.packages;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/trilium
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}

    cp -r ./* $out/share/trilium
    ln -s $out/share/trilium/trilium $out/bin/trilium

    ln -s $out/share/trilium/resources/app/src/public/images/trilium.svg $out/share/icons/hicolor/scalable/apps/trilium.svg
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';


  # This "shouldn't" be needed, remove when possible :)
  preFixup = ''
    wrapProgram $out/bin/trilium --prefix LD_LIBRARY_PATH : "${atomEnv.libPath}"
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    inherit description;
    homepage = https://github.com/zadam/trilium;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ emmanuelrosa dtzWill ];
  };
}
