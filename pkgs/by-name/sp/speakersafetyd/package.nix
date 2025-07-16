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
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "speakersafetyd";
    tag = finalAttrs.version;
    hash = "sha256-sSGoF2c5HfPM2FBrBJwJ9NvExYijGx6JH1bJp3epfe0=";
  };

  cargoHash = "sha256-9XbrIY1VwnHtqi/ZfS952SyjNjA/TJRdOqCsPReZI8o=";

  patches = [
    ./remove-install-paths.patch
  ];

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace speakersafetyd.service \
      --replace-fail "User=speakersafetyd" \
                     "" \
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
    "TMPFILESDIR=lib/tmpfiles.d"
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
      normalcea
      flokli
      yuka
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
