{ lib
, fetchFromGitHub
, stdenvNoCC
, curl
, xclip
, wl-clipboard
, stdenv
}:
stdenvNoCC.mkDerivation rec {
  pname = "videoclip";
  version = "unstable-2023-11-01";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "509b6b624592dbac6f2d7e0c4bc92a76460e7129";
    hash = "sha256-fMuoBWM0bmRhdRoGxLYsqBjy2H+AVwOvVeva3SBR/EA=";
  };

  dontBuild = true;

  substitute =
    ''
      substituteInPlace platform.lua \
        --replace \'curl\' \'${lib.getExe curl}\' \
    ''
    + lib.optionalString stdenv.isLinux ''
      --replace xclip ${lib.getExe xclip} \
      --replace wl-copy ${lib.getExe' wl-clipboard "wl-copy"}
    '';

  patchPhase = ''
    runHook prePatch

    ${substitute}

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mpv/scripts/videoclip
    cp *.lua $out/share/mpv/scripts/videoclip

    runHook postInstall
  '';

  passthru.scriptName = "videoclip";

  meta = with lib; {
    description = "Easily create videoclips with mpv";
    homepage = "https://github.com/Ajatt-Tools/videoclip";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ayes-web ];
  };
}
