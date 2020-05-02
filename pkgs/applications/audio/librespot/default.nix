{lib, fetchFromGitHub, pkgs, alsaLib,
withALSA ? false,
withPulseAudio ? true, libpulseaudio ? null,
withPortAudio ? false, portaudio ? null,
pkgconfig, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sdbjv8w2mfpv82rx5iy4s532l1767vmlrg9d8khnvh8vrm2lshy";
  };

  cargoSha256 = "0zi50imjvalwl6pxl35qrmbg74j5xdfaws8v69am4g9agbfjvlms";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ alsaLib ]
    ++ lib.optional withPulseAudio libpulseaudio
    ++ lib.optional withPortAudio portaudio;

  cargoBuildFlags = [
      "--no-default-features"
      "--features"
      "${lib.optionalString withALSA "alsa-backend,"}${lib.optionalString withPulseAudio "pulseaudio-backend,"}${lib.optionalString withPortAudio "portaudio-backend"}"
    ];

  meta = with lib; {
    description = "Open Source Spotify client library";
    homepage = "https://github.com/librespot-org/librespot";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms = platforms.all;
  };
}
