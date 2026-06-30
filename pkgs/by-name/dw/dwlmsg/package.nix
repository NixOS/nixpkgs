{
  lib,
  fetchFromGitea,
  pkg-config,
  stdenv,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwlmsg";
  version = "git";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "notchoc";
    repo = "dwlmsg";
    rev = "3fc9780f4e";
    hash = "sha256-LTrWb9IxGvm9yUy47+Om9V5GbLygDcEAbVAExGWgFQw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-scanner
  ];

  outputs = [
    "out"
  ];

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "PREFIX=$(out)"
  ];

  strictDeps = true;

  # required for whitespaces in makeFlags
  __structuredAttrs = true;

  meta = with lib; {
    description = "A CLI tool for IPC communications with DWL window manager";
    longDescription = "This tool allows for scripting of window manager features in DWL, It relies on the IPC patch for DWL";
    homepage = "https://codeberg.org/notchoc/dwlmsg";
    license = licenses.gpl3Plus;
    #maintainers = with maintainers; [ Person1873 ];
    platforms = platforms.all;
  };

})
