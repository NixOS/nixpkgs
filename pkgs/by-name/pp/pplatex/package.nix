{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pcre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pplatex";
  version = "1.0-unstable-2025-05-07";

  src = fetchFromGitHub {
    owner = "stefanhepp";
    repo = "pplatex";
    rev = "9f6cfb23c3b578f14ad2664cd754cb4a66dc790e";
    sha256 = "sha256-vI7CujOn2J4qWiykTQj8wyRmfeTDvR0eiFKB2ElTNUk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  cmakeFlags = [
    # https://github.com/NixOS/nixpkgs/issues/445447
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  buildInputs = [
    pcre
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 src/pplatex "$out"/bin/pplatex
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to reformat the output of latex and friends into readable messages";
    mainProgram = "pplatex";
    homepage = "https://github.com/stefanhepp/pplatex";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.unix;
  };
})
