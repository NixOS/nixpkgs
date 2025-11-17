{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  keyutils,
  libkrb5,
  openafs,
  perl,
  pkg-config,
  enableSetPAG ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kstart";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "rra";
    repo = "kstart";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-MGWL4oNc0MZTGWqBEt2wRTkqoagiUTDrS0kz4ewbZZA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs = [
    keyutils
    libkrb5
    openafs
  ];

  configureFlags = [
    "--enable-silent-rules"
  ]
  ++ (lib.optional enableSetPAG "--enable-setpag");

  preBuild = ''
    for f in k5start krenew; do
      pod2man --release="${finalAttrs.version}" --center="kstart" docs/"$f".pod >docs/"$f".1
    done
  '';

  doCheck = true;
  preCheck = ''
    patchShebangs tests
  '';

  outputs = [
    "out"
    "man"
  ];

  meta = with lib; {
    outputsToInstall = [
      "out"
      "man"
    ];
    description = "Modified version of kerberos tools that support automatic ticket refresh";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
})
