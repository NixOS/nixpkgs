{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  libssh,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtrlib";
  version = "0.8.0";

  src = fetchFromGitHub {
    repo = "rtrlib";
    owner = "rtrlib";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ISb4ojcDvXY/88GbFMrA5V5+SGE6CmE5D+pokDTwotQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libssh
    openssl
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/rtrlib.pc \
      --replace '=''${prefix}//' '=/'
  '';

  meta = {
    description = "Open-source C implementation of the RPKI/Router Protocol client";
    homepage = "https://github.com/rtrlib/rtrlib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Anillc ];
    platforms = lib.platforms.all;
  };
})
