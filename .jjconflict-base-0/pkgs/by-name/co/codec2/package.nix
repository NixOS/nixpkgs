{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freedvSupport ? false,
  lpcnetfreedv,
}:

stdenv.mkDerivation rec {
  pname = "codec2";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = "${version}";
    hash = "sha256-69Mp4o3MgV98Fqfai4txv5jQw2WpoPuoWcwHsNAFPQM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals freedvSupport [
    lpcnetfreedv
  ];

  postInstall = ''
    install -Dm0755 src/{c2enc,c2sim,freedv_rx,freedv_tx,cohpsk_*,fdmdv_*,fsk_*,ldpc_*,ofdm_*} -t $out/bin/
  '';

  # Swap keyword order to satisfy SWIG parser
  postFixup = ''
    sed -r -i 's/(\<_Complex)(\s+)(float|double)/\3\2\1/' $out/include/$pname/freedv_api.h
  '';

  cmakeFlags =
    [
      # RPATH of binary /nix/store/.../bin/freedv_rx contains a forbidden reference to /build/
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
    ]
    ++ lib.optionals freedvSupport [
      "-DLPCNET=ON"
    ];

  meta = with lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = "https://www.rowetel.com/codec2.html";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
