{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "mro-unicode";
  version = "unstable-2013-05-25";

  src = fetchurl {
    url = "https://github.com/phjamr/MroUnicode/raw/f297de070f7eba721a47c850e08efc119d3bfbe8/MroUnicode-Regular.ttf";
    hash = "sha256-hcQmTuRWxaU5KEMXg/O0b1olE8YxXWz0PAlqAJknR/0=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/MroUnicode-Regular.ttf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/phjamr/MroUnicode";
    description = "Unicode-compliant Mro font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
