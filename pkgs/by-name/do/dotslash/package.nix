{ lib, rustPlatform, fetchCrate
, testers, nix-update-script, dotslash
}:

rustPlatform.buildRustPackage rec {
  pname = "dotslash";
  version = "0.4.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-EcYDMuAVSCzpHgekSQsQfv/PNDj0jB7Ht9LRgm+tgd0=";
  };

  cargoHash = "sha256-w2P1J2TDtGqrJYQWTrkaF41iTRDttB1pdfF11sCbHCA=";
  doCheck = false; # http tests

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      package = dotslash;
    };
  };

  meta = with lib; {
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
    license = with licenses; [ asl20 /* or */ mit ];
    mainProgram = "dotslash";
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
