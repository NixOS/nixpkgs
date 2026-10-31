{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gif_load";
  version = "unstable-2019-01-06";

  src = fetchFromGitHub {
    owner = "hidefromkgb";
    repo = "gif_load";
    rev = "74b674de2704bc1b20fc3bf482a5ee3e774b67c5";
    hash = "sha256-MpfwXLqQhnv1XTu84ei5NjNnSZfbKAx3tOCfTJce7tI=";
  };

  installPhase = ''
    mkdir -p $out/include/${finalAttrs.pname}
    cp gif_load.h $out/include/${finalAttrs.pname}
  '';

  meta = with lib; {
    description = "A slim, fast and header-only GIF loader written in C";
    homepage = "https://github.com/hidefromkgb/gif_load.git";
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
})
