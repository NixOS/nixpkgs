{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  nim,
  openssl,
  makeWrapper,

  nix-update-script,
}:

buildNimPackage (
  final: prev: {
    pname = "nimble";
    version = "0.20.1";

    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nimble";
      rev = "v${final.version}";
      hash = "sha256-DV/cheAoG0UviYEYqfaonhrAl4MgjDwFqbbKx7jUnKE=";
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

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Package manager for the Nim programming language";
      homepage = "https://github.com/nim-lang/nimble";
      changelog = "https://github.com/nim-lang/nimble/releases/tag/v${final.version}";
      license = lib.licenses.bsd3;
      mainProgram = "nimble";
      maintainers = [ lib.maintainers.daylinmorgan ];
    };
  }
)
