{
  lib,
  stdenv,
  fetchurl,
}:
let
  rev = "c65c03ca794b37247fbd4c13c23f315a95809eaa";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "c-intro-and-ref";
  version = "0.0";

  src = fetchurl {
    url = "mirror://gnu/c-intro-and-ref/c-intro-and-ref-${finalAttrs.version}.tar.gz";
    hash = "sha256-1fo5/RQz4sTA6lY4wBYuvubsAP/tYoYhI3sQAlFx60o=";
  };

  meta = {
    description = "Explains the C language for use with the GNU Compiler Collection (GCC) on the GNU/Linux system and other systems";
    longDescription = ''
      This manual explains the C language for use with the GNU Compiler
      Collection (GCC) on the GNU/Linux operating system and other systems. We
      refer to this dialect as GNU C. If you already know C, you can use this as
      a reference manual.
    '';
    homepage = "https://www.gnu.org/software/c-intro-and-ref/";
    changelog = "https://git.savannah.nongnu.org/cgit/c-intro-and-ref.git/plain/ChangeLog?id=${rev}";
    license = lib.licenses.fdl13Plus;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.all;
  };
})
