{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, libgit2
, git
, pkg-config
, zlib
}:

rustPlatform.buildRustPackage {
  pname = "git-agecrypt";
  version = "unstable-2023-07-14";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "git-agecrypt";
    rev = "945b80556d8848f6e85a8cc0053f9020bdc8b359";
    hash = "sha256-6FjyJRYGyZt+uvYjXWvXI7DGq/+BNZHSSAT/DhOsF/E=";
  };

  cargoHash = "sha256-QCV0DT0kcDRMzVc+9uTn9FYPpf+xvKJbakP6CHRcibo=";

  nativeBuildInputs = [ pkg-config git ];

  buildInputs = [ libgit2 zlib ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;


  meta = with lib; {
    description = "Alternative to git-crypt using age instead of GPG.";
    homepage = "https://github.com/vlaci/git-agecrypt";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kuznetsss ];
    mainProgram = "git-agecrypt";
  };
}
