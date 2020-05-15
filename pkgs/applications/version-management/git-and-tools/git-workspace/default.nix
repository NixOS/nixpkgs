{ stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n025bnisg724d9pjcindxagj1ry63sxr0pplpkh2f2qffzm78pi";
  };

  cargoSha256 = "0ikyp6pdlw2c1gr1n1snjbdmblm0fs5swx5awy36jskii99q6kr1";

  buildInputs = with stdenv; lib.optional isDarwin Security;

  meta = with stdenv.lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
