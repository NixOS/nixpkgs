{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "dotslash";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rgcvpr6/Xss4zDR7IRXL2THAtUQL6WE8Mv9XuM9unBI=";
  };

  cargoHash = "sha256-WkC+8epqCJWIU1f5kCLsqgGiSvWZH1mbZabQUnGVwB4=";
  doCheck = false; # http tests

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
