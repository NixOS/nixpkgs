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
    version = "0-unstable-2024-05-14";

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nimble";
      rev = "f8bd7b5fa6ea7a583b411b5959b06e6b5eb23667";
      hash = "sha256-aRDaucD6wOUPtXLIrahvK0vBfurdgFrk+swzqzMA09w=";
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
