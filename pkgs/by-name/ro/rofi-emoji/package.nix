{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,

  autoreconfHook,
  pkg-config,

  cairo,
  glib,
  libnotify,

  x11Support ? true,
  rofi-unwrapped,
  xclip,
  xdotool,

  waylandSupport ? false,
  rofi-wayland-unwrapped,
  wl-clipboard,
  wtype,

  nix-update-script,
}:
let
  rofi = if waylandSupport then rofi-wayland-unwrapped else rofi-unwrapped;

  adapterBinPath = lib.makeBinPath (
    [
      libnotify
    ]
    ++ lib.optionals waylandSupport [
      wl-clipboard
      wtype
    ]
    ++ lib.optionals x11Support [
      xclip
      xdotool
    ]
  );
in

stdenv.mkDerivation (final: {
  pname = "rofi-emoji";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rofi-emoji";
    rev = "v${final.version}";
    hash = "sha256-Amaz+83mSPue+pjZq/pJiCxu5QczYvmJk6f96eraaK8=";
  };

  patches = [
    # Look for plugin-related files in $out/lib/rofi
    ./0001-Patch-plugindir-to-output.patch
  ];

  postPatch = ''
    patchShebangs --host clipboard-adapter.sh
  '';

  postFixup = ''
    chmod +x $out/share/rofi-emoji/clipboard-adapter.sh
    wrapProgram $out/share/rofi-emoji/clipboard-adapter.sh \
     --prefix PATH ":" ${adapterBinPath}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    cairo
    glib
    rofi
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Emoji selector plugin for Rofi (built against ${rofi.pname})";
    homepage = "https://github.com/Mange/rofi-emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cole-h
      Mange
    ];
    platforms = lib.platforms.linux;
  };
})
