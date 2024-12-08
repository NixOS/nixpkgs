{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nim,
  openssl,
  makeWrapper,
}:

buildNimPackage (
  final: prev: {
    pname = "nimble";
    version = "0.16.2";

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nimble";
      rev = "v${final.version}";
      hash = "sha256-MVHf19UbOWk8Zba2scj06PxdYYOJA6OXrVyDQ9Ku6Us=";
    };

    lockFile = ./lock.json;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ openssl ];

    nimFlags = [ "--define:git_revision_override=${final.src.rev}" ];

    doCheck = false; # it works on their machine

    postInstall = ''
      wrapProgram $out/bin/nimble \
        --suffix PATH : ${lib.makeBinPath [ nim ]}
    '';

    meta = {
      description = "Package manager for the Nim programming language";
      homepage = "https://github.com/nim-lang/nimble";
      license = lib.licenses.bsd3;
      mainProgram = "nimble";
    };
  }
)
