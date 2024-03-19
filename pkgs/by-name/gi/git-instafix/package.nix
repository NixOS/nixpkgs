{ git
, lib
, libgit2
, makeWrapper
, rustPlatform
, stdenv
, fetchFromGitHub
}:
let
  inherit
    (lib)
    licenses
    maintainers
    ;

  version = "0.2.1";
in
rustPlatform.buildRustPackage {
  pname = "git-instafix";
  inherit version;

  src = fetchFromGitHub {
    owner = "quodlibetor";
    repo = "git-instafix";
    rev = "v${version}";
    hash = "sha256-rWHiaZji3GECsiMqvEGC/tF+K29ZLlY6+TCNxtixHQo=";
  };

  cargoHash = "sha256-t5vlr3YxjRPqMHwPqVjWul4RdSg0hiTWUQxcJmGKiTQ=";

  buildInputs = [ libgit2 ];
  nativeCheckInputs = [ git ];

  meta = {
    description = "Quickly fix up an old commit using your currently-staged changes";
    mainProgram = "git-instafix";
    homepage = "https://github.com/quodlibetor/git-instafix";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ mightyiam ];
    changelog = "https://github.com/quodlibetor/git-instafix/releases/tag/v${version}";
    broken = stdenv.isDarwin;
  };
}
