{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, libkrun
, makeWrapper
, passt
, sommelier
, mesa
, opengl-driver ? mesa.drivers
, withSommelier ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "muvm";
  version = "0-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = pname;
    rev = "98e2563f2380ff33eb4527c845f8792808c212c6";
    hash = "sha256-KLHfm48a2/nPwnozMwpqxTFlvEezx9SbxI63yy7sxgc=";
  };

  cargoHash = "sha256-8Bj8tfFVUDMB2ixcvS7A/Y7Lev4vT1NGm6WiBzYmOSU=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    (libkrun.override {
      withBlk = true;
      withGpu = true;
      withNet = true;
    })
  ];

  # Allow for sommelier to be disabled as it can cause problems.
  wrapArgs = [
    "--prefix PATH : ${lib.makeBinPath (lib.optional withSommelier [ sommelier ] ++ [ passt ])}"
  ];

  postFixup = ''
    wrapProgram $out/bin/muvm $wrapArgs \
      --set-default OPENGL_DRIVER ${opengl-driver}
  '';

  meta = {
    description = "Run programs from your system in a microVM";
    homepage = "https://github.com/AsahiLinux/muvm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    platforms = libkrun.meta.platforms;
    mainProgram = "krun";
  };
}
