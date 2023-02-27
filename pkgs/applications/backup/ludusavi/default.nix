{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, bzip2
, fontconfig
, freetype
, libGL
, libX11
, libXcursor
, libXrandr
, libXi
, gnome
, libsForQt5
}:

rustPlatform.buildRustPackage rec {
  pname = "ludusavi";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3nh1EhjiH+dUBw3CNeFSg/+Wkxr5AYgVdM1HzVKbqJI=";
  };

  cargoSha256 = "sha256-l9jYqmKC0GJL9MSRbrNng4rO6/dx4q8EVCxfuin4v6E=";

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    libX11
    libXcursor
    libXrandr
    libXi
  ];

  postInstall = ''
    install -Dm644 assets/com.github.mtkennerly.ludusavi.metainfo.xml -t \
      "$out/share/metainfo/"
    install -Dm644 assets/icon.png \
      "$out/share/icons/hicolor/64x64/apps/${pname}.png"
    install -Dm644 assets/icon.svg \
      "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
    install -Dm644 "assets/${pname}.desktop" -t "$out/share/applications/"
    install -Dm644 assets/MaterialIcons-Regular.ttf -t "$out/share/fonts/TTF/"
    install -Dm644 LICENSE -t "$out/share/licenses/${pname}/"
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        bzip2
        fontconfig
        freetype
        libX11
        libXcursor
        libXrandr
        libXi
      ];
    in
    ''
      patchelf --set-rpath "${libPath}" "$out/bin/$pname"
      wrapProgram $out/bin/$pname --prefix PATH : ${lib.makeBinPath [ gnome.zenity libsForQt5.kdialog ]}
    '';


  meta = with lib; {
    description = "Backup tool for PC game saves";
    homepage = "https://github.com/mtkennerly/ludusavi";
    changelog = "https://github.com/mtkennerly/ludusavi/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
