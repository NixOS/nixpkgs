{
  lib,
  stdenv,
  fetchurl,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schilytools";
  version = "2024-03-21";

  src = fetchurl {
    url = "https://codeberg.org/schilytools/schilytools/releases/download/${finalAttrs.version}/schily-${finalAttrs.version}.tar.bz2";
    hash = "sha256-HytYLdVMzDkZ/Jft5NTWvRmwEaDEARgo8bmqAzRo0us=";
  };

  postPatch = ''
    substituteInPlace RULES/rules.prg \
      --replace "/bin/" ""
  '';

  dontConfigure = true;

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.IOKit
  ];

  makeFlags = [
    # TODO: Try to unset DESTDIR, according to #65718
    "DESTDIR=${placeholder "out"}"
    "INS_BASE=/"
  ];

  meta = {
    description = "A collection of tools written or formerly managed by Jörg Schilling";
    homepage = "https://codeberg.org/schilytools/schilytools";
    license = with lib.licenses; [
      cddl
      lgpl21Only
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.all;
  };
})
