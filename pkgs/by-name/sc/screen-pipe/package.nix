{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,

  pkg-config,
  cmake,

  dbus,
  ffmpeg,
  oniguruma,
  onnxruntime,
  openssl,

  alsa-lib,
  xorg,

  apple-sdk_15,
  xcbuild,
}:

rustPlatform.buildRustPackage rec {
  pname = "screen-pipe";
  version = "0.2.58";

  src = fetchFromGitHub {
    owner = "louis030195";
    repo = "screen-pipe";
    rev = "v${version}";
    hash = "sha256-IydgUGZlSe9o0LxL2i/6cheOqM/hc4xTrqf0fSgG5Kc=";
  };

  patches = [
    (replaceVars ./hardcode-paths.patch {
      ffmpeg_exe_path = lib.getExe ffmpeg;
    })
  ];

  cargoPatches = [
    # This adds the missing Cargo.lock file
    # I also had to re-lock and override dependency versions
    # to avoid having duplicate pname-version ids (fetchCargoVendor doesn't support it ATM)
    ./lock-deps.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-FQa9Iwk+kZzl2cfFUdmIG5X4DS5JvrJ1t0WkYQz+oFM=";

  nativeBuildInputs =
    [
      pkg-config
      rustPlatform.bindgenHook
      cmake # for libsamplerate-sys
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild
    ];

  dontUseCmakeConfigure = true;

  buildInputs =
    [
      dbus
      oniguruma
      onnxruntime
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      xorg.libxcb
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_15
    ];

  buildFeatures = lib.optional stdenv.hostPlatform.isDarwin "metal";

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  doCheck = false; # Tests fail to build

  meta = with lib; {
    description = "Personalized AI powered by what you've seen, said, or heard";
    homepage = "https://github.com/louis030195/screen-pipe";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "screen-pipe";
  };
}
