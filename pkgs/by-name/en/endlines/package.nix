{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "endlines";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "mdolidon";
    repo = "endlines";
    rev = finalAttrs.version;
    hash = "sha256-M0IyY/WXR8qv9/qx5G0pG3EKqMoZAP3fJTZ6sSSMMyQ=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    homepage = "https://github.com/mdolidon/endlines";
    description = "Easy conversion between new-line conventions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zedseven ];
    mainProgram = "endlines";
    platforms = lib.platforms.unix;
  };
})
