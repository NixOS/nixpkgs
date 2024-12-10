{
  stdenv,
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  alsa-lib,
  rust,
}:

rustPlatform.buildRustPackage rec {
  pname = "speakersafetyd";
  version = "0.1.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-I1fL1U4vqKxPS1t6vujMTdi/JAAOCcPkvUqv6FqkId4=";
  };
  cargoHash = "sha256-Adwct+qFhUsOIao8XqNK2zcn13DBlQNA+X4aRFeIAXM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace speakersafetyd.service --replace "/usr" "$out"
    substituteInPlace Makefile --replace "target/release" "target/${rust.lib.toRustTargetSpec stdenv.hostPlatform}/$cargoBuildType"
    # creating files in /var does not make sense in a nix package
    substituteInPlace Makefile --replace 'install -dDm0755 $(DESTDIR)/$(VARDIR)/lib/speakersafetyd/blackbox' ""
  '';

  installFlags = [
    "BINDIR=$(out)/bin"
    "UNITDIR=$(out)/lib/systemd/system"
    "UDEVDIR=$(out)/lib/udev/rules.d"
    "SHAREDIR=$(out)/share"
    "TMPFILESDIR=$(out)/lib/tmpfiles.d"
  ];

  dontCargoInstall = true;

  meta = with lib; {
    description = "A userspace daemon written in Rust that implements an analogue of the Texas Instruments Smart Amp speaker protection model";
    mainProgram = "speakersafetyd";
    homepage = "https://github.com/AsahiLinux/speakersafetyd";
    maintainers = with maintainers; [ yuka ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
