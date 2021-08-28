{ fetchFromGitHub, lib, python3, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv_thumbnail_script";
  version = "unstable-2020-01-16";

  src = fetchFromGitHub {
    owner = "theamm";
    repo = pname;
    rev = "682becf5b5115c2a206b4f0bdee413d4be8b5bef";
    sha256 = "0dgfrb8ypc5vlq35kzn423fm6l6348ivl85vb6j3ccc9a51xprw3";
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
    homepage = "https://github.com/theamm/mpv_thumbnail_script";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ figsoda ];
  };
}
