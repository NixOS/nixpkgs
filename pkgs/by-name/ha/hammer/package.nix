{
  fetchFromGitLab,
  glib,
  lib,
  pkg-config,
  scons,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hammer";
  version = "nightly_20220416";

  src = fetchFromGitLab {
    domain = "gitlab.special-circumstanc.es";
    owner = "hammer";
    repo = "hammer";
    rev = finalAttrs.version;
    sha256 = "sha256-xMZhUnycGeHkNZfHQ2d9mETti8HwGHZNskFqh9f0810=";
  };

  nativeBuildInputs = [
    pkg-config
    scons
  ];
  buildInputs = [ glib ];

  meta = {
    description = "Bit-oriented parser combinator library";
    longDescription = ''
      Hammer is a parsing library. Like many modern parsing libraries, it
      provides a parser combinator interface for writing grammars as inline
      domain-specific languages, but Hammer also provides a variety of parsing
      backends. It's also bit-oriented rather than character-oriented, making it
      ideal for parsing binary data such as images, network packets, audio, and
      executables.
    '';
    homepage = "https://gitlab.special-circumstanc.es/hammer/hammer";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ azahi ];
  };
})
