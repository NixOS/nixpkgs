{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kbdlight";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "hobarrera";
    repo = "kbdlight";
    rev = "v${finalAttrs.version}";
    sha256 = "1f08aid1xrbl4sb5447gkip9lnvkia1c4ap0v8zih5s9w8v72bny";
  };

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace 4755 0755
  '';

  meta = {
    homepage = "https://github.com/hobarrera/kbdlight";
    description = "Very simple application that changes MacBooks' keyboard backlight level";
    mainProgram = "kbdlight";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.womfoo ];
    platforms = lib.platforms.linux;
  };
})
