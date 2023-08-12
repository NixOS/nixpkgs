{ lib, stdenvNoCC, fetchFromGitHub, python3 }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-thumbnail-script";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "marzzzello";
    repo = "mpv_thumbnail_script";
    rev = version;
    sha256 = "sha256-6J1eeuSYyUJmWLIl9WsQ4NzQOBJNO3Cnl5jcPEal4vM=";
  };

  nativeBuildInputs = [ python3 ];

  postPatch = ''
    patchShebangs concat_files.py
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp mpv_thumbnail_script_{client_osc,server}.lua $out/share/mpv/scripts
    runHook postInstall
  '';

  passthru.scriptName = "mpv_thumbnail_script_{client_osc,server}.lua";

  meta = with lib; {
    description = "A lua script to show preview thumbnails in mpv's OSC seekbar";
    homepage = "https://github.com/marzzzello/mpv_thumbnail_script";
    changelog = "https://github.com/marzzzello/mpv_thumbnail_script/releases/tag/${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ figsoda ];
  };
}
