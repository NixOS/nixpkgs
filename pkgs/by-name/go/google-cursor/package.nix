{
  stdenvNoCC,
  fetchzip,
  lib,
}:

let
  colors = [
    {
      name = "Black";
      hash = "sha256-pb2U9j1m8uJaILxUxKqp8q9FGuwzZsQvhPP3bfGZL5I=";
    }
    {
      name = "Blue";
      hash = "sha256-PmJeGShQLIC7ceRwQvSbphqz19fKptksZeHKi9QSL5Y=";
    }
    {
      name = "Red";
      hash = "sha256-/X81jLoWaw4UMoDRf1f6oaKKRWexQc4PAACy3doV4Kc=";
    }
    {
      name = "White";
      hash = "sha256-eT/Zy6O6TBD6G8q/dg+9rNYDHutLLxEY1lvLDP90b+g=";
    }
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "google-cursor";
  version = "2.0.0";

  sourceRoot = ".";
  srcs = map (
    color:
    (fetchzip {
      url = "https://github.com/ful1e5/Google_Cursor/releases/download/v${finalAttrs.version}/GoogleDot-${color.name}.tar.gz";
      name = "GoogleDot-${color.name}";
      hash = color.hash;
    })
  ) colors;

  postInstall = ''
    mkdir -p $out/share/icons
    cp -r GoogleDot-* $out/share/icons
  '';

  meta = with lib; {
    description = "Opensource cursor theme inspired by Google";
    homepage = "https://github.com/ful1e5/Google_Cursor";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ quadradical ];
  };
})
