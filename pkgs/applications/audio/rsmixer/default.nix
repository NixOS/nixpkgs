{ lib, rustPlatform, fetchFromGitHub, libpulseaudio, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "rsmixer";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "jantap";
    repo = pname;
    rev = "v${version}";
    sha256 = "HvmX3GCMExkQ74OGiYsDlsNfJk+i258A5seNy3e+wCw=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  buildInputs = [ libpulseaudio ];
  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/rsmixer --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libpulseaudio ]}"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rsmixer --help
  '';

  meta = with lib; {
    description = "A PulseAudio volume mixer written in rust";
    homepage = "https://github.com/jantap/rsmixer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nkje ];
  };
}
