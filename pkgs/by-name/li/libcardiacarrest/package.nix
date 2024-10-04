{
  lib,
  fetchFromGitHub,
  glib,
  libpulseaudio,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcardiacarrest";
  version = "12.2.8"; # <PA API version>.<version>

  src = fetchFromGitHub {
    owner = "oxij";
    repo = "libcardiacarrest";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-JLWFLsjP16oHGG3sBwAPFqozyPBm2++xnR+9wRl/MW8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib ];

  makeFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  postInstall = ''
    moveToOutput $out/include $dev
    moveToOutput $out/lib/pkgconfig $dev
    moveToOutput $out/lib/cmake $dev
  '';

  meta = {
    homepage = "https://github.com/oxij/libcardiacarrest";
    description = "Trivial implementation of libpulse PulseAudio library API";
    longDescription = ''
      libcardiacarrest is a trivial implementation of libpulse PulseAudio
      library API that unconditionally (but gracefully) fails to connect to the
      PulseAudio daemon and does nothing else.

      apulse and pressureaudio (which uses apulse internally) are an inspiration
      for this but unlike those two projects libcardiacarrest is not an
      emulation layer, all it does is it gracefully fails to provide the
      requested PulseAudio service hoping the application would try something
      else (e.g. ALSA or JACK).
    '';
    changelog = "https://github.com/oxij/libcardiacarrest/releases/tag/v${finalAttrs.version}";
    inherit (libpulseaudio.meta) license platforms; # "same as PA headers"
    maintainers = with lib.maintainers; [ oxij ]; # also the author
  };
})
