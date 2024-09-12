{ stdenv
, lib
, rustPlatform
, fetchCrate
, pkg-config
, alsa-lib
, rust
}:

rustPlatform.buildRustPackage rec {
  pname = "speakersafetyd";
  version = "1.0.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-I1RTtD5V4Z8R8zed/b4FitHyE7gFAja5YcA+z0VvSX0=";
  };
  cargoHash = "sha256-8Dmts6SCRrZqyI+pdfgqsXfJy9Hqspbdb6EpQChMKDA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace speakersafetyd.service --replace "/usr" "$out"
    substituteInPlace Makefile --replace "target/release" "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
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
    description = "Userspace daemon written in Rust that implements an analogue of the Texas Instruments Smart Amp speaker protection model";
    mainProgram = "speakersafetyd";
    homepage = "https://github.com/AsahiLinux/speakersafetyd";
    maintainers = with maintainers; [ flokli yuka ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
