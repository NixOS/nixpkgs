{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, qtbase
, qtquickcontrols
, qmake
, makeDesktopItem
}:

# we now have libqmatrixclient so a future version of tensor that supports it
# should use that

mkDerivation rec {
  pname = "tensor";
  version = "unstable-2017-02-21";

  src = fetchFromGitHub {
    owner = "davidar";
    repo = "tensor";
    rev = "f3f3056d770d7fb4a21c610cee7936ee900569f5";
    sha256 = "sha256-aR6TsfUxsxoSDaIWYgRCwd7BCgekSEqY6LpDoQ5DNqY=";
    fetchSubmodules = true;
  };

  buildInputs = [ qtbase qtquickcontrols ];
  nativeBuildInputs = [ qmake ];

  desktopItem = makeDesktopItem {
    name = "tensor";
    exec = "@bin@";
    icon = "tensor.png";
    comment = meta.description;
    desktopName = "Tensor Matrix Client";
    genericName = meta.description;
    categories = [ "Chat" "Utility" ];
    mimeTypes = [ "application/x-chat" ];
  };

  installPhase = if stdenv.isDarwin then ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r tensor.app $out/Applications/tensor.app

    runHook postInstall
  '' else ''
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

  meta = with lib; {
    homepage = "https://matrix.org/docs/projects/client/tensor.html";
    description = "Cross-platform Qt5/QML-based Matrix client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
  };
}
