{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  httplib,
  openssl,
  pugixml,
  sqlite,
  wxwidgets_3_2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elfeed2";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "elfeed2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tc5gTKNpjl4v4XqBZeWYxVidV6U7hKW5KeD3PBE5iV0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    httplib
    openssl
    pugixml
    sqlite
    wxwidgets_3_2
    zlib
  ];

  cmakeFlags = [
    "-DDEPS=LOCAL"
    "-DwxWidgets_CONFIG_EXECUTABLE=${lib.getExe' (lib.getDev wxwidgets_3_2) "wx-config"}"
  ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/elfeed2 $out/bin/
  '';

  meta = with lib; {
    description = "The Elfeed feed reader experience without Emacs";
    homepage = "https://github.com/skeeto/elfeed2";
    changelog = "https://github.com/skeeto/elfeed2/releases/tag/${finalAttrs.version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [
      dywedir
    ];
    platforms = platforms.all;
  };
})
