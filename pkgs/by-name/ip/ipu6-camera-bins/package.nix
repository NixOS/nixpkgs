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
  version = "unstable-2025-06-27";

  src = fetchFromGitHub {
    repo = "ipu6-camera-bins";
    owner = "intel";
    rev = "30e87664829782811a765b0ca9eea3a878a7ff29";
    hash = "sha256-YPPzuK13o2jnRSB3ORoMUU5E9/IifKVSetAqZHRofhw=";
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
    for lib in $out/lib/lib*.so.*; do \
      lib=''${lib##*/}; \
      ln -s $lib $out/lib/''${lib%.*}; \
    done

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
