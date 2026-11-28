{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "obs-scene-as-transition";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "StreamUPTips";
    repo = "obs-streamup-scene-as-transition";
    tag = "${version}";
    hash = "sha256-g/IAk7wqrSJI5Kfn7XDH4Oj25EA2TIcKLtoaGN2VL7Q=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OBS Studio plugin that will allow you to use a Scene as a transition";
    homepage = "https://github.com/StreamUPTips/obs-streamup-scene-as-transition";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
