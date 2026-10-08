{
  stdenv,
  lib,
  addDriverRunpath,
  alsa-lib,
  autoPatchelfHook,
  cairo,
  fetchurl,
  flac,
  gcc14,
  # gssdp,
  # gupnp,
  gupnp-av,
  lame,
  libgmpris,
  libusb-compat-0_1,
  llvmPackages_19,
  mpg123,
  rpmextract,
  wavpack,

  callPackage,
}:
let
  rygel-hqplayerd = callPackage ./rygel.nix { };
in
stdenv.mkDerivation rec {
  pname = "hqplayerd";
  version = "5.13.2-39";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/hqplayerd/fc37/hqplayerd-${version}.fc37.x86_64.rpm";
    hash = "sha256-4wB32xFYpGcBdLqSZFkNXoS7IerPS8f6KIpn13ulqUY=";
  };

  unpackPhase = ''
    rpmextract $src
  '';

  nativeBuildInputs = [
    addDriverRunpath
    autoPatchelfHook
    rpmextract
  ];

  buildInputs = [
    alsa-lib
    cairo
    flac
    gcc14.cc.lib
    rygel-hqplayerd
    # gssdp
    # gupnp
    gupnp-av
    lame
    libgmpris
    libusb-compat-0_1
    llvmPackages_19.openmp
    mpg123
    wavpack
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # executables
    mkdir -p $out
    cp -rv ./usr/bin $out/bin

    # libs
    mkdir -p $out
    cp -rv ./opt/hqplayerd/lib $out

    # configuration
    mkdir -p $out/etc
    cp -rv ./etc/hqplayer $out/etc/

    # systemd service file
    mkdir -p $out/lib/systemd
    cp -rv ./usr/lib/systemd/system $out/lib/systemd/

    # documentation
    mkdir -p $out/share/doc
    cp -rv ./usr/share/doc/hqplayerd $out/share/doc/

    # misc service support files
    mkdir -p $out/var/lib
    cp -rv ./var/lib/hqplayer $out/var/lib/
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/hqplayerd.service \
      --replace /usr/bin/hqplayerd $out/bin/hqplayerd \
      --replace "NetworkManager-wait-online.service" ""
  '';

  # NB: addDriverRunpath needs to run _after_ autoPatchelfHook, which runs in
  # postFixup, so we tack it on here.
  doInstallCheck = true;
  installCheckPhase = ''
    addDriverRunpath $out/bin/hqplayerd
    $out/bin/hqplayerd --version
  '';

  passthru = {
    rygel = rygel-hqplayerd;
  };

  meta = {
    # libsoup 2.4 and its dependents (specifically gupnp and gssdp) were
    # removed due to being insecure and having many known vulnerabilities. this
    # thus no longer builds. this may be unbroken by updating to hqplayer 6.0,
    # as it ostensibly removes the need for rygel and gupnp at all.
    broken = true;
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software embedded HD-audio player";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
