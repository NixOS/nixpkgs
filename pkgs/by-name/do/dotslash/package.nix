{
  lib,
  rustPlatform,
  fetchCrate,
  testers,
  nix-update-script,
  dotslash,
}:

rustPlatform.buildRustPackage rec {
  pname = "dotslash";
  version = "0.5.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-VFesGum2xjknUuCwIojntdst5dmhvZb78ejJ2OG1FVI=";
  };

  cargoHash = "sha256-+FWDeR4AcFSFz0gGQ8VMvX68/F0yEm25cNfHeedqsWE=";
  doCheck = false; # http tests

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      package = dotslash;
    };
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://dotslash-cli.com";
    description = "Simplified multi-platform executable deployment";
    longDescription = ''
      DotSlash is a command-line tool that is designed to facilitate fetching an
      executable, verifying it, and then running it. It maintains a local cache
      of fetched executables so that subsequent invocations are fast.

      DotSlash helps keeps heavyweight binaries out of your repo while ensuring
      your developers seamlessly get the tools they need, ensuring consistent
      builds across platforms.
    '';
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20 # or
      mit
    ];
    mainProgram = "dotslash";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ thoughtpolice ];
=======
    maintainers = with maintainers; [ thoughtpolice ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
