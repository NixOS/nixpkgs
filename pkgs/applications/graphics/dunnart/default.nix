{ mkDerivation
, fetchFromGitHub
, lib
, qtbase
, qtsvg
, qmake
, wrapQtAppsHook
}:

mkDerivation {
  pname = "dunnart";
  version = "2016-02-02";

  src = fetchFromGitHub {
    owner = "mjwybrow";
    repo = "dunnart";
    rev = "af43b7c9acc16c83c72684959c9b643b84633b0f";
    sha256 = "1pa359dv6lb6mfxdl2c2vsfz0y7g8w8xngzr9hi4a7fjr08ipn21";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  buildInputs = [
    qtsvg
  ];

  meta = with lib; {
    description = "Constraint-based diagram editor";
    # TODO add license
    maintainers = [ maintainers.raboof ];
    # OSX not tested
    platforms = platforms.linux;
  };
}
