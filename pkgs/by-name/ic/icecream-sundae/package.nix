{
  fetchFromGitHub,
  glib,
  icecream,
  lib,
  libcap_ng,
  libnl,
  lzo,
  meson,
  ncurses,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icecream-sundae";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "JPEWdev";
    repo = "icecream-sundae";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-XFDVkPRwjbJa79lLMeMN78uuHGQRJ8rH10dKipCDjM8=";
  };

  passthru.updateScript = nix-update-script { };

  buildInputs = [
    ncurses
    glib
    libnl
    icecream
    lzo
    libcap_ng
    zstd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = with lib; {
    description = "TUI for monitoring icecream clusters";
    homepage = "https://github.com/JPEWdev/icecream-sundae/";
    license = licenses.gpl2Plus;
    mainProgram = "icecream-sundae";
    maintainers = with lib.maintainers; [
      x-zvf
    ];
  };
})
