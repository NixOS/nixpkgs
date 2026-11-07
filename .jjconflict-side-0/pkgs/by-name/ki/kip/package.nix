{
  lib,
  stdenv,
  fetchFromGitLab,
  arpa2cm,
  arpa2common,
  bison,
  cacert,
  cmake,
  cyrus_sasl,
  e2fsprogs,
  flex,
  freediameter,
  gnutls,
  json_c,
  libev,
  libkrb5,
  libressl,
  openssl,
  pkg-config,
  python3,
  quick-sasl,
  quickder,
  quickmem,
  unbound,
  nix-update-script,
}:
let
  python-with-packages = python3.withPackages (
    ps: with ps; [
      asn1ate
      colored
      pyparsing
      setuptools
      six
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kip";
  version = "0.15.0";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "kip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A+tPaImjd9j1Vq69Dgh3j86xI/OcovwTZSULLkOVZaI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    bison
    cacert
    cmake
    cyrus_sasl
    flex
    libkrb5
    openssl
    pkg-config
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    cyrus_sasl
    e2fsprogs
    freediameter
    gnutls
    json_c
    libev
    libkrb5
    libressl
    python-with-packages
    quick-sasl
    quickder
    quickmem
    unbound
  ];

  cmakeFlags = [
    (lib.cmakeFeature "freeDiameter_EXTENSION_DIR" "${placeholder "out"}/lib/freeDiameter")
  ];

  preBuild = ''
    patchShebangs test
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyful Identity Protocol — symmetric-key encryption and signing via an online KIP Service";
    homepage = "https://gitlab.com/arpa2/kip";
    license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
  };
})
