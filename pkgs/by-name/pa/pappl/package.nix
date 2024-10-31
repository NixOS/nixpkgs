{
  lib,
  stdenv,
  fetchFromGitHub,
  avahi,
  cups,
  gnutls,
  libjpeg,
  libpng,
  libusb1,
  pkg-config,
  withPAMSupport ? true,
  pam,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "pappl";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "pappl";
    rev = "refs/tags/v${version}";
    hash = "sha256-Npry3H+QbAH19hoqAZuOwjpZwCPhOLewD8uKZlo4gdQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      cups
      libjpeg
      libpng
      libusb1
      zlib
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      # upstream mentions these are not needed for Mac
      # see: https://github.com/michaelrsweet/pappl#requirements
      avahi
      gnutls
    ]
    ++ lib.optionals withPAMSupport [
      pam
    ];

  # testing requires some networking
  # doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/pappl-makeresheader --help
  '';

  enableParallelBuilding = true;

  meta = {
    description = "C-based framework/library for developing CUPS Printer Applications";
    changelog = "https://github.com/michaelrsweet/pappl/blob/v${version}/CHANGES.md";
    mainProgram = "pappl-makeresheader";
    homepage = "https://github.com/michaelrsweet/pappl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux; # should also work for darwin, but requires additional work
    maintainers = [ lib.maintainers.NotAShelf ];
  };
}
