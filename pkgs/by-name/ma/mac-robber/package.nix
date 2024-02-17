{ lib
, stdenv
, fetchurl
, fetchpatch
, glibc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mac-robber";
  version = "1.02";

  src = fetchurl {
    url = "mirror://sourceforge/project/mac-robber/mac-robber/${finalAttrs.version}/mac-robber-${finalAttrs.version}.tar.gz";
    hash = "sha256-WJXTMuyNh+FfIUQcYVRbf2iDCi7iyWfTgXc70IUEgG0=";
  };

  patches = [
    # add GCC hardening.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/mac-robber/-/raw/b6a59d78e2f58fbfab7f1b3ed9b72531d28693ca/debian/patches/10_add-GCC-hardening.patch";
      hash = "sha256-OyZbNha82iuaFOnyWyXTD38UakQa8WKlWL3tO9z9/l8=";
    })
  ];

  buildInputs = [
    glibc.static
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp mac-robber $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A digital investigation tool that collects data from allocated files in a mounted file system";
    mainProgram = "mac-robber";
    homepage = "https://www.sleuthkit.org/mac-robber/";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
})
