{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  expat,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ipu7-camera-bins";
  version = "unstable-2025-01-15";

  src = fetchFromGitHub {
    repo = "ipu7-camera-bins";
    owner = "intel";
    rev = "f4a353c7c2f0dc98416cd847a74724e8d6e07519";
    hash = "sha256-4LOFOIdBSMITNA1RtH8TDwPd+r/0lyTA6RBPeD0exO8=";
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

    # REVIEW file exists now
    # There is no LICENSE file in the src
    # install -m 0644 -D LICENSE $out/share/doc/LICENSE

    runHook postInstall
  '';

  postFixup = ''
    for lib in $out/lib/lib*.so.*; do \
      lib=''${lib##*/}; \
      target=$out/lib/''${lib%.*}; \
      if [ ! -e "$target" ]; then \
        ln -s "$lib" "$target"; \
      fi \
    done

    for pcfile in $out/lib/pkgconfig/*.pc; do
      substituteInPlace $pcfile \
        --replace 'prefix=/usr' "prefix=$out"
    done
  '';

  meta = with lib; {
    description = "IPU firmware and proprietary image processing libraries";
    homepage = "https://github.com/intel/ipu7-camera-bins";
    license = licenses.issl;
    sourceProvenance = with sourceTypes; [
      binaryFirmware
    ];
    maintainers = [ lib.maintainers.pseudocc ];
    platforms = [ "x86_64-linux" ];
  };
})
