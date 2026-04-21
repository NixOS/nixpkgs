{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  udevCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "speakersafetyd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "speakersafetyd";
    tag = finalAttrs.version;
    hash = "sha256-tHHoVJqWcip5u/e7M9l74opdzfe0Y9Q6ItIT7w7XfA8=";
  };

  cargoHash = "sha256-v0w/eA/qd9xBivgq7BgdaGRGDdX2NA1gbRgv84cB6d4=";

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace speakersafetyd.service \
      --replace-fail "/usr" \
                     "$out"

    substituteInPlace Makefile \
      --replace-fail "target/release" \
                     "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType" \
  '';

  installFlags = [
    "DESTDIR=$(out)"
    "BINDIR=bin"
    "UNITDIR=lib/systemd/system"
    "UDEVDIR=lib/udev/rules.d"
    "SHAREDIR=share"
  ];

  dontCargoInstall = true;
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Userspace daemon that implements the Smart Amp protection model";
    mainProgram = "speakersafetyd";
    homepage = "https://github.com/AsahiLinux/speakersafetyd";
    maintainers = with lib.maintainers; [
      flokli
      yuka
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
