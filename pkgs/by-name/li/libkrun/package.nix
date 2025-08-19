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
  withGpu ? false,
  withSound ? false,
  withNet ? false,
  sevVariant ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B11f7uG/oODwkME2rauCFbVysxUtUrUmd6RKeuBdnUU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-bcHy8AfO9nzSZKoFlEpPKvwupt3eMb+A2rHDaUzO3/U=";
  };

  # Make sure libkrunfw can be found by dlopen()
  # FIXME: This wasn't needed previously. What changed?
  env.RUSTFLAGS = toString (
    map (flag: "-C link-arg=" + flag) [
      "-Wl,--push-state,--no-as-needed"
      (if sevVariant then "-lkrunfw-sev" else "-lkrunfw")
      "-Wl,--pop-state"
    ]
  );

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
  ]
  ++ lib.optional (sevVariant || withGpu) pkg-config;

  buildInputs = [
    (libkrunfw.override { inherit sevVariant; })
    glibc
    glibc.static
  ]
  ++ lib.optionals withGpu [
    libepoxy
    libdrm
    virglrenderer
  ]
  ++ lib.optional withSound pipewire
  ++ lib.optional sevVariant openssl;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optional withBlk "BLK=1"
  ++ lib.optional withGpu "GPU=1"
  ++ lib.optional withSound "SND=1"
  ++ lib.optional withNet "NET=1"
  ++ lib.optional sevVariant "SEV=1";

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    mv $out/lib64/pkgconfig $dev/lib/
    mv $out/include $dev/
  '';

  meta = with lib; {
    description = "Dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
    ];
    platforms = libkrunfw.meta.platforms;
  };
})
