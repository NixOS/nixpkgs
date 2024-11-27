{
  stdenv,
  cmake,
  geant4,
}:

{
  example_B1 = stdenv.mkDerivation {
    name = "${geant4.name}-test-example_B1";

    inherit (geant4) src;

    nativeBuildInputs = [ cmake ];
    buildInputs = [ geant4 ];
    nativeCheckInputs = with geant4.data; [
      G4EMLOW
      G4ENSDFSTATE
      G4PARTICLEXS
      G4PhotonEvaporation
    ];

    prePatch = ''
      cd examples/basic/B1
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck

      ./exampleB1 ../run2.mac

      runHook postCheck
    '';
  };
}
