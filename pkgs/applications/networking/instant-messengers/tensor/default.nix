{ stdenv, fetchgit, qtbase, qtquickcontrols, qmake, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "tensor-git-${version}";
  version = "2017-02-21";

  src = fetchgit {
    url             = "https://github.com/davidar/tensor.git";
    rev             = "f3f3056d770d7fb4a21c610cee7936ee900569f5";
    sha256          = "19in8c7a2hxsx2c4lj540w5c3pn1882645m21l91mcriynqr67k9";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  buildInputs = [ qtbase qtquickcontrols ];
  nativeBuildInputs = [ qmake ];

  desktopItem = makeDesktopItem {
    name        = "tensor";
    exec        = "@bin@";
    icon        = "tensor.png";
    comment     = meta.description;
    desktopName = "Tensor Matrix Client";
    genericName = meta.description;
    categories  = "Chat;Utility";
    mimeType    = "application/x-chat";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 tensor $out/bin/tensor
    install -Dm644 client/logo.png \
                   $out/share/icons/hicolor/512x512/apps/tensor.png
    install -Dm644 ${desktopItem}/share/applications/tensor.desktop \
                   $out/share/applications/tensor.desktop

    substituteInPlace $out/share/applications/tensor.desktop \
      --subst-var-by bin $out/bin/tensor

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://matrix.org/docs/projects/client/tensor.html;
    description = "Cross-platform Qt5/QML-based Matrix client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
    inherit version;
  };
}
