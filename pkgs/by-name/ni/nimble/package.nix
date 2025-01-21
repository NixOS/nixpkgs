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
    version = "0.16.4";

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nimble";
      rev = "v${final.version}";
      hash = "sha256-ASodRov4rO/IhjQRRdqVnLWMG1voXWM9F6R6VJd9qkM=";
      fetchSubmodules = true;
    };

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
