{ lib, buildNimPackage, fetchFromGitHub, nim, makeWrapper }:

buildNimPackage (final: prev: {
  pname = "nimble";
  version = "0.14.2";

  requiredNimVersion = 1;

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "nimble";
    rev = "v${final.version}";
    hash = "sha256-8b5yKvEl7c7wA/8cpdaN2CSvawQJzuRce6mULj3z/mI=";
  };

  nativeBuildInputs = [ makeWrapper ];

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
})
