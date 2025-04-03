{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  expat,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ipu6-camera-bins";
  version = "unstable-2024-09-27";

  src = fetchFromGitHub {
    repo = "ipu6-camera-bins";
    owner = "intel";
    rev = "98ca6f2a54d20f171628055938619972514f7a07";
    hash = "sha256-DAjAzHMqX41mrfQVpDUJLw4Zjb9pz6Uy3TJjTGIkd6o=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    (lib.getLib stdenv.cc.cc)
    expat
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp --no-preserve=mode --recursive \
      lib \
      include \
      $out/

    # There is no LICENSE file in the src
    # install -m 0644 -D LICENSE $out/share/doc/LICENSE

    runHook postInstall
  '';

  postFixup = ''
    for pcfile in $out/lib/pkgconfig/*.pc; do
      substituteInPlace $pcfile \
        --replace 'prefix=/usr' "prefix=$out"
    done
  '';

  meta = with lib; {
    description = "IPU firmware and proprietary image processing libraries";
    homepage = "https://github.com/intel/ipu6-camera-bins";
    license = licenses.issl;
    sourceProvenance = with sourceTypes; [
      binaryFirmware
    ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
})
