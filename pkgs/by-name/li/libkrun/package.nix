{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  pkg-config,
  glibc,
  openssl,
  libepoxy,
  libdrm,
  pipewire,
  virglrenderer,
  libkrunfw,
  rustc,
  withBlk ? false,
  withNet ? false,
  withGpu ? false,
  withSound ? false,
  withTimesync ? false,
  variant ? null,
}:

assert lib.elem variant [
  null
  "sev"
  "tdx"
];

let
  libkrunfw' = (libkrunfw.override { inherit variant; });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun" + lib.optionalString (variant != null) "-${variant}";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VhlFyYJ/TH12I3dUq0JTus60rQEJq5H4Pm1puCnJV5A=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-dK3V7HCCvTqmQhB5Op2zmBPa9FO3h9gednU9tpQk+1U=";
  };

  # Make sure libkrunfw can be found by dlopen()
  env.RUSTFLAGS = toString (
    map (flag: "-C link-arg=" + flag) [
      "-Wl,--push-state,--no-as-needed"
      ("-lkrunfw" + lib.optionalString (variant != null) "-${variant}")
      "-Wl,--pop-state"
    ]
  );

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
  ]
  ++ lib.optional (variant == "sev" || variant == "tdx" || withGpu) pkg-config;

  buildInputs = [
    libkrunfw'
    glibc
    glibc.static
  ]
  ++ lib.optionals withGpu [
    libepoxy
    libdrm
    virglrenderer
  ]
  ++ lib.optional withSound pipewire
  ++ lib.optional (variant == "sev" || variant == "tdx") openssl;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optional withBlk "BLK=1"
  ++ lib.optional withNet "NET=1"
  ++ lib.optional withGpu "GPU=1"
  ++ lib.optional withSound "SND=1"
  ++ lib.optional withTimesync "TIMESYNC=1"
  ++ lib.optional (variant == "sev") "SEV=1"
  ++ lib.optional (variant == "tdx") "TDX=1";

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    mv $out/lib64/pkgconfig $dev/lib/
    mv $out/include $dev/
  '';

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
    ];
    platforms = libkrunfw'.meta.platforms;
  };
})
