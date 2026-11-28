{
  lib,
  stdenv,
  bundlerEnv,
  ruby,
  buildRubyGem,
  mplayer,
  imagemagick,
  ffmpeg,

  versionCheckHook,
  bundlerUpdateScript,
}:
let
  pname = "lolcommits";
  version = "0.18.0";

  deps = bundlerEnv rec {
    inherit ruby version;
    name = "${pname}-deps-${version}";
    gemdir = ./.;
  };

  runtimeDeps =
    [
      ffmpeg
      imagemagick
    ]
    # On Linux lolcommits requires using mplayer's v4l2 backend
    # (/dev/video*) to capture the webcam
    ++ lib.optional stdenv.hostPlatform.isLinux (mplayer.override { v4lSupport = true; });
in
buildRubyGem {
  inherit pname version ruby;
  gemName = pname;

  source.sha256 = "sha256-hmFAKFmxUEcmjff9QZ2hf4ZPmsGCEyFxcKyb2KNYzro=";

  propagatedBuildInputs = [ deps ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  preFixup = ''
    wrapProgram $out/bin/lolcommits --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  passthru.updateScript = bundlerUpdateScript "lolcommits";

  meta = {
    description = "Git-based selfies for software developers";
    homepage = "https://lolcommits.github.io/";
    license = with lib.licenses; [ lgpl3Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.unix;
    mainProgram = "lolcommits";
  };
}
