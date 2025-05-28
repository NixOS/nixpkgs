{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-recursion-effect";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-recursion-effect";
    tag = "${finalAttrs.version}";
    hash = "sha256-PeWJy423QbX4NULuS15LJ/IR/W+tXCJD9TjZdJOGk6A=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  # Fix OBS API deprecations warnings
  patches = [
    (fetchpatch {
      url = "https://github.com/exeldro/obs-recursion-effect/commit/889a8484d5c0eb33267b44ccda545a8fadc189a5.diff";
      hash = "sha256-J2GnsoPUTqvEkuBuAae2TrxXMQg0Sm3dq75ZjGN65IE=";
    })
  ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = {
    description = "Plugin for OBS Studio to add recursion effect to a source using a filter";
    homepage = "https://github.com/exeldro/obs-recursion-effect";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
