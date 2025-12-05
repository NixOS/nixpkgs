{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  pqcscan,
  jq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pqcscan";
  version = "0.7.0-dev";

  src = fetchFromGitHub {
    owner = "anvilsecure";
    repo = "pqcscan";
    rev = "7f30a649e31124f9cc2d746c25c26aec47d47b91"; # Oct 2025
    hash = "sha256-u6zvEPW4g0Pug0McNEOjr5LHG1VeSo9VBOtkV+ZN9JA=";
  };

  cargoHash = "sha256-Itx1+ekxNBra5DB4H3qqLu4R5dgE5UsAMaWX2oTXIAM=";

  passthru = {
    tests.simple = runCommand "${finalAttrs.pname}-test" { } ''
      mkdir -p $out
      # does not require a server to be running to create json
      ${pqcscan}/bin/pqcscan ssh-scan -t "169.254.0.1:22" -o $out/result.json
      if ${jq}/bin/jq -e '.results' -r $out/result.json &> /dev/null
      then
        echo "Test succeeded"
      else
        echo "Test failed"
        exit 1
      fi
    '';
  };

  meta = with lib; {
    description = "Post-Quantum Cryptography Scanner";
    homepage = "https://github.com/anvilsecure/pqcscan";
    license = licenses.bsd2;
    maintainers = [ maintainers.heywoodlh ];
    mainProgram = "pqcscan";
  };
})
