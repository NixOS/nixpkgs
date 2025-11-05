{
  stdenv,
  lib,
  makeWrapper,
  ghcWithPackages,
  packages ? (_: [ ]),
}:
let
  blucontrolEnv = ghcWithPackages (self: [ self.blucontrol ] ++ packages self);
in
stdenv.mkDerivation {
  pname = "blucontrol-with-packages";
  version = blucontrolEnv.version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    makeWrapper ${blucontrolEnv}/bin/blucontrol $out/bin/blucontrol \
      --prefix PATH : ${lib.makeBinPath [ blucontrolEnv ]}
  '';

  # trivial derivation
  preferLocalBuild = true;

  meta = with lib; {
    description = "Configurable blue light filter";
    mainProgram = "blucontrol";
    longDescription = ''
      This application is a blue light filter, with the main focus on configurability.
      Configuration is done in Haskell in the style of xmonad.
      Blucontrol makes use of monad transformers and allows monadic calculation of gamma values and recoloring. The user chooses, what will be captured in the monadic state.
    '';
    license = licenses.bsd3;
    homepage = "https://github.com/jumper149/blucontrol";
    platforms = platforms.unix;
    maintainers = with maintainers; [ jumper149 ];
  };
}
