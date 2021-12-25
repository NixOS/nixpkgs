{ lib
, rustPlatform
, fetchFromGitHub
, glib
, pkg-config
, wrapGAppsHook
, gtk3
}:

rustPlatform.buildRustPackage rec {
  pname = "image-roll";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "weclaw1";
    repo = pname;
    rev = version;
    sha256 = "sha256-NhZ0W9WBOIRe2nE4jQJ9WgfduKhHd+222feUCay4atw=";
  };

  cargoSha256 = "sha256-7sV8v/npmdOgTMtnww/VoK1Kp4Na9Go95XLcfdgkTik=";

  nativeBuildInputs = [ glib pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 ];

  postInstall = ''
    install -Dm444 src/resources/com.github.weclaw1.ImageRoll.desktop -t $out/share/applications/
    install -Dm444 src/resources/com.github.weclaw1.ImageRoll.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 src/resources/com.github.weclaw1.ImageRoll.metainfo.xml -t $out/share/metainfo/
  '';

  meta = with lib; {
    description = "Simple and fast GTK image viewer with basic image manipulation tools";
    homepage = "https://github.com/weclaw1/image-roll";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
