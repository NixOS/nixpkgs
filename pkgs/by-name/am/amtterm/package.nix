{
  fetchFromGitHub,
  lib,
  stdenv,
  makeWrapper,
  gtk3,
  openssl,
  perl,
  perlPackages,
  pkg-config,
  vte,
  withGamt ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amtterm";
  version = "1.7-1-unstable-2023-10-27";

  buildInputs =
    (with perlPackages; [
      perl
      SOAPLite
    ])
    ++ [ openssl ]

    ++ lib.optionals withGamt [
      gtk3
      vte
    ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  src = fetchFromGitHub {
    owner = "kraxel";
    repo = "amtterm";
    rev = "ed5da502cbb150982ad982211ad9475414b8689a";
    hash = "sha256-JwS2agmJJ6VcGLkNbkFRb5bzKV8el1DMDjalmLnOdE8=";
  };

  makeFlags = [
    "prefix=$(out)"
    "STRIP="
    "USE_OPENSSL=1"
  ];

  postInstall = "wrapProgram $out/bin/amttool --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "Intel AMT® SoL client + tools";
    homepage = "https://www.kraxel.org/cgit/amtterm/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
