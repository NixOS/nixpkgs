{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  libpulseaudio,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pamix";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "patroclos";
    repo = "pamix";
    tag = finalAttrs.version;
    hash = "sha256-l6NCqqrq11sYJyVshEMCU6ixC5E3lSSMc0+4ye17hLQ=";
  };

  patches = [
    # ncurses-6.3 support, included in next release
    (fetchpatch {
      name = "ncurses-6.3-p1.patch";
      url = "https://github.com/patroclos/PAmix/commit/3400b9c048706c572373e4617b4d5fcdb8dd2505.patch";
      sha256 = "0rw56a844pz876ad9p8hfvn2fkd5rh29gpp47h55g08spf0vwb2z";
    })
    (fetchpatch {
      name = "ncurses-6.3-p2.patch";
      url = "https://github.com/patroclos/PAmix/commit/5ef67fc5ef6fc0dc0b48ff07ba48093881561d9c.patch";
      sha256 = "0f8shpdv2swxdz04bkqgmkvl6c17r5mn4slzr7xd6pvw8hh51p4h";
    })
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace-fail "/etc" "$out/etc/xdg"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    ncurses
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pulseaudio terminal mixer";
    homepage = "https://github.com/patroclos/PAmix";
    changelog = "https://github.com/patroclos/PAmix/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ericsagnes ];
    mainProgram = "pamix";
  };
})
