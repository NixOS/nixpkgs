{
  lib,
  fetchFromGitHub,
  buildNimPackage,
  makeWrapper,
  nix-update-script,

  openssl,
  nim,
  useSystemNim ? true,
}:
buildNimPackage (finalAttrs: {

  pname = "nimble";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "nimble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jeo29dR/sTzdMzPrO1sGzo5zf0FMul5MhukW9xeKqEg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ openssl ];

  nimFlags = [ "--define:git_revision_override=${finalAttrs.src.tag}" ];

  doCheck = false; # it works on their machine

  postInstall =
    let
      wrapperFlags = lib.concatStringsSep " " (
        [ "--suffix PATH : ${lib.makeBinPath [ nim ]}" ]
        ++ lib.optionals useSystemNim [
          "--add-flag \"--nim:${lib.getExe nim}\""
          "--add-flag '--useSystemNim'"
        ]
      );
    in
    "wrapProgram $out/bin/nimble ${wrapperFlags}";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package manager for the Nim programming language";
    homepage = "https://github.com/nim-lang/nimble";
    changelog = "https://github.com/nim-lang/nimble/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "nimble";
    teams = [ lib.teams.nim ];
  };
})
