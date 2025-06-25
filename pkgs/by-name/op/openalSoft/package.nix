{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  removeReferencesTo,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  dbusSupport ? !stdenv.hostPlatform.isDarwin,
  dbus,
  pipewireSupport ? !stdenv.hostPlatform.isDarwin,
  pipewire,
  pulseSupport ? !stdenv.hostPlatform.isDarwin,
  libpulseaudio,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "openal-soft";
  version = "1.24.2";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "openal-soft";
    rev = version;
    sha256 = "sha256-ECrIkxMACPsWehtJWwTmoYj6hGcsdxwVuTiQywG36Y8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    removeReferencesTo
  ];

  buildInputs =
    lib.optional alsaSupport alsa-lib
    ++ lib.optional dbusSupport dbus
    ++ lib.optional pipewireSupport pipewire
    ++ lib.optional pulseSupport libpulseaudio;

  cmakeFlags =
    [
      # Automatically links dependencies without having to rely on dlopen, thus
      # removes the need for NIX_LDFLAGS.
      "-DALSOFT_DLOPEN=OFF"

      # allow oal-soft to find its own data files (e.g. HRTF profiles)
      "-DALSOFT_SEARCH_INSTALL_DATADIR=1"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # https://github.com/NixOS/nixpkgs/issues/183774
      "-DALSOFT_BACKEND_OSS=OFF"
    ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = with lib; {
    description = "OpenAL alternative";
    homepage = "https://openal-soft.org/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ftrvxmtrx ];
    platforms = platforms.unix;
  };
}
