{ stdenv, lib, rustPlatform , fetchFromGitHub,
openssl, alsaLib, pkgconfig,
withPulseAudio ? false, libpulseaudio,
withDbusMpris ? false, dbus }:
rustPlatform.buildRustPackage rec {
  name = "spotifyd-${version}";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "0xdv8c4nb427b81r57srcqn3gylblxfs8hbk1x3ckjsxzwn8vj9l";
  };

  buildInputs = [ openssl alsaLib pkgconfig ]
  ++ (lib.optional withPulseAudio libpulseaudio)
  ++ (lib.optional withDbusMpris dbus);

  cargoSha256 = "1gbgirng21ak0kl3fiyr6lxwzrjd5v79gcrbzf941nb8y8rlvz7a";

  cargoBuildFlags = [ "--features" "${lib.optionalString withPulseAudio "pulseaudio_backend"} ${lib.optionalString withDbusMpris "dbus_mpris"}" ];

  meta = with stdenv.lib; {
    description = "A spotify daemon";
    homepage = https://github.com/Spotifyd/spotifyd;
    license = licenses.gpl3;
    maintainers = [ maintainers.bobvanderlinden ];
    platforms = platforms.linux;
  };
}
