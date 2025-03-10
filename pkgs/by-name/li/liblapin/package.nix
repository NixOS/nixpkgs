{
  stdenv,
  lib,
  fetchFromGitHub,
  sfml,
  libffcall,
  libusb-compat-0_1,
  libudev-zero,
}:

stdenv.mkDerivation {
  pname = "liblapin";
  version = "0-unstable-2024-05-20";

  src = fetchFromGitHub {
    owner = "Damdoshi";
    repo = "LibLapin";
    rev = "27955d24f3efd10fe4f556a4f292d731813d3de3";
    hash = "sha256-h8LuhTgFOFnyDeFeoEanD64/nmDyLeh6R9tw9X6GP8g=";
  };

  prePatch = ''
    # camera module fails to build with opencv, due to missing V4L2 support
    rm -rf src/camera

    substituteInPlace Makefile \
      --replace-fail "/bin/echo" "echo"
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 liblapin.a $out/lib/liblapin.a

    rm -rf include/private
    cp -r include $out

    runHook postInstall
  '';

  buildInputs = [
    sfml
    libffcall
    libusb-compat-0_1
    libudev-zero
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Multimedia library for rookies and prototyping";
    homepage = "https://liblapin.org?lan=en";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
