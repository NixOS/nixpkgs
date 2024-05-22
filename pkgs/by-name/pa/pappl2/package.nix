{
  lib,
  stdenv,
  fetchFromGitHub,
  libcups3,
  libjpeg,
  libpng,
  libusb1,
  pam,
  pkg-config,
  nix-update-script,
  enableJpeg ? true,
  enablePng ? true,
  enableUsb ? true,
  enablePam ? true,
}:

stdenv.mkDerivation {
  pname = "pappl2";
  version = "0-unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "pappl";
    rev = "0803683ad4255a58b35762c36d5abcd771e0fd45";
    sha256 = "sha256-tptZ0JSk25F+pmlrO2yH6q8WB8T73NiYsjiA06i4Qdw=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ libcups3 ]
    ++ lib.optional enableJpeg libjpeg
    ++ lib.optional enablePng libpng
    ++ lib.optional enableUsb libusb1
    ++ lib.optional enablePam pam;

  configureFlags =
    [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
    ]
    ++ lib.optional enableJpeg "--enable-libjpeg"
    ++ lib.optional enablePng "--enable-libpng"
    ++ lib.optional enableUsb "--enable-libusb"
    ++ lib.optional (!enablePam) "--disable-libpam";

  doCheck = false; # testing requires some networking
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/pappl2-makeresheader --help
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C-based framework/library for developing CUPS Printer Applications";
    mainProgram = "pappl2-makeresheader";
    homepage = "https://github.com/michaelrsweet/pappl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
