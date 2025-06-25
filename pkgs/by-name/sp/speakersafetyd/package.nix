{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  udevCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "speakersafetyd";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "speakersafetyd";
    tag = finalAttrs.version;
    hash = "sha256-ULAGdYUfeMlPki6DT2vD+tvDqKMxJtG16o/+7+ERsv4=";
  };

  cargoHash = "sha256-DnOnqi60JsRX8yqEM/5zZ3yX/rk85/ruwL3aW1FRXKg=";

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace speakersafetyd.service --replace "/usr" "$out"
    substituteInPlace Makefile --replace "target/release" "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
    # creating files in /var does not make sense in a nix package
    substituteInPlace Makefile --replace 'install -dDm0755 $(DESTDIR)/$(VARDIR)/lib/speakersafetyd/blackbox' ""
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

  meta = with lib; {
    description = "Userspace daemon that implements the Smart Amp protection model";
    mainProgram = "speakersafetyd";
    homepage = "https://github.com/AsahiLinux/speakersafetyd";
    maintainers = with maintainers; [
      normalcea
      flokli
      yuka
    ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
})
