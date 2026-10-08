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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "speakersafetyd";
    tag = finalAttrs.version;
    hash = "sha256-tUAHkCEteyFqF9XKQ7TLzYLU11Iy89Wlp251tI1w+Zw=";
  };

  cargoHash = "sha256-9SGNhP0ccr5Spiz5B6rfnYMGGR7Q5fDivL2EZuwKwkU=";

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
                     "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
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
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
