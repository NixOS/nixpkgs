{ lib
, rustPlatform
, fetchFromGitHub
, glib
, pkg-config
, wrapGAppsHook
, gtk4
}:

rustPlatform.buildRustPackage rec {
  pname = "image-roll";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "weclaw1";
    repo = pname;
    rev = version;
    sha256 = "sha256-CC40TU38bJFnbJl2EHqeB9RBvbVUrBmRdZVS2GxqGu4=";
  };

  cargoSha256 = "sha256-cUE2IZOunR/NIo/qytORRfNqCsf87LfpKA8o/v4Nkhk=";

  nativeBuildInputs = [ glib pkg-config wrapGAppsHook ];

  buildInputs = [ gtk4 ];

  checkFlags = [
    # fails in the sandbox
    "--skip=file_list::tests"

    # sometimes fails on darwin
    "image_list::tests::save_current_image_overwrites_image_at_current_image_path_when_filename_is_set_to_none"
  ];

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
