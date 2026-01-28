{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  ffmpeg,
  feh,
  imagemagick_light,
  lz4,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "resnap";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "cloudsftp";
    repo = "resnap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uw7lRQv+NKSJzb29MIr6ki5BvLpetKHdeudHtyQnc4A=";
  };

  nativeBuildInputs = [ makeWrapper ];

  runtimeInputs = [
    ffmpeg
    feh
    imagemagick_light
    lz4
  ];

  installPhase = ''
    runHook preInstall

    install -D reSnap.sh $out/bin/reSnap

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/bin/reSnap \
      --replace-fail "\$0" reSnap

    wrapProgram $out/bin/reSnap \
      --suffix PATH : "${lib.makeBinPath finalAttrs.runtimeInputs}"
  '';

  meta = {
    description = "Take screnshots of your reMarkable tablet over SSH";
    homepage = "https://github.com/cloudsftp/reSnap";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ _404wolf ];
    mainProgram = "reSnap";
  };
})
