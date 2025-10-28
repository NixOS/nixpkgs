{
  stdenv,
  libusb-compat-0_1,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "micronucleus";
  version = "2.6";

  sourceRoot = "${finalAttrs.src.name}/commandline";

  src = fetchFromGitHub {
    owner = "micronucleus";
    repo = "micronucleus";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IngVHeYgPUwSsboTZ5h55iLUxtdBSdugiLk5HbyHIvI=";
  };

  buildInputs = [ libusb-compat-0_1 ];
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "STATIC="
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/udev
    cp micronucleus $out/bin
    cp 49-micronucleus.rules $out/lib/udev
  '';

  meta = {
    description = "Upload tool for micronucleus";
    mainProgram = "micronucleus";
    homepage = "https://github.com/micronucleus/micronucleus";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      cab404
      kuflierl
    ];
  };
})
