{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  doxygen,
  # cert generators depend on GPL-2.0-only code, which conflicts with Apache
  withCertGenerators ? false,
}:

stdenv.mkDerivation rec {
  pname = "leancrypto";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "leancrypto";
    rev = "v${version}";
    hash = "sha256-fZKsdmahG0uIn9z5CbY0nKPaClayC3u+juT0LeDgW+E=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch =
    ''
      patchShebangs addon/*.sh apps/tests/*.sh

      # remove GPLv2 code that shouldn't be used for userspace builds
      # https://github.com/smuellerDD/leancrypto/blob/8920e81b57504bf7504238bcb148f4abc12ae39b/LICENSE
      rm internal/api/errno_private.h internal/api/errno_private-base.h
    ''
    # make sure we don't link this GPL-2.0-only file
    + lib.optionalString (!withCertGenerators) ''
      rm asn1/src/asn1_encoder_helper.c
    '';

  mesonFlags = [
    (lib.mesonEnable "x509_generator" withCertGenerators)
    (lib.mesonEnable "pkcs7_generator" withCertGenerators)
  ];

  nativeBuildInputs = [
    meson
    ninja
    doxygen
  ];

  doCheck = true;

  meta = {
    homepage = "https://leancrypto.org/";
    description = "Lean cryptographic library usable for bare-metal environments";
    license =
      with lib.licenses;
      [
        gpl2Plus
        bsd3
        asl20
        bsd2
        mit
        isc
        publicDomain
        cc0
      ]
      ++ lib.optional withCertGenerators [
        gpl2Only
        unfree
      ];
    maintainers = with lib.maintainers; [
      solomonv
    ];
    platforms = lib.platforms.all;
  };
}
