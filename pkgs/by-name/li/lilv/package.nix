{
  lib,
  stdenv,
  fetchurl,
  lv2,
  meson,
  ninja,
  pkg-config,
  python3,
  libsndfile,
  serd,
  sord,
  sratom,
  gitUpdater,

  # test derivations
  pipewire,
}:

stdenv.mkDerivation rec {
  pname = "lilv";
  version = "0.24.26";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.xz";
    hash = "sha256-Iv7tMLwPlSOEolwvb0sE5tQ4NkCHmO1lqKk0wFXV2Kw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];
  buildInputs = [
    libsndfile
    serd
    sord
    sratom
  ];
  propagatedBuildInputs = [ lv2 ];

  mesonFlags = [
    (lib.mesonOption "docs" "disabled")
    # Tests require building a shared library.
    (lib.mesonEnable "tests" (!stdenv.hostPlatform.isStatic))
  ]
  # Add nix and NixOS specific lv2 paths
  # The default values are from: https://github.com/lv2/lilv/blob/master/src/lilv_config.h
  ++ lib.optional stdenv.hostPlatform.isDarwin (
    lib.mesonOption "default_lv2_path" "~/.lv2:~/Library/Audio/Plug-Ins/LV2:"
    + "/usr/local/lib/lv2:/usr/lib/lv2:"
    + "/Library/Audio/Plug-Ins/LV2:"
    + "~/.nix-profile/lib/lv2"
  )
  ++ lib.optional stdenv.hostPlatform.isLinux (
    lib.mesonOption "default_lv2_path" "~/.lv2:/usr/local/lib/lv2:/usr/lib/lv2:"
    + "~/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2"
  );

  passthru = {
    tests = {
      inherit pipewire;
    };
    updateScript = gitUpdater {
      url = "https://gitlab.com/lv2/lilv.git";
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    homepage = "http://drobilla.net/software/lilv";
    description = "C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
