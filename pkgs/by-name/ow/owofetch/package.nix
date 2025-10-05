{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "owofetch";

  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "netthier";
    repo = "owofetch-rs";
    rev = "v${version}";
    sha256 = "sha256-I8mzOUvm72KLLBumpgn9gNyx9FKvUrB4ze1iM1+OA18=";
  };

  cargoHash = "sha256-0ON1h8+ruLOvBR7Q/hOIW6j+BjfPAAuYA2wrUYj59Ow=";

  meta = with lib; {
    description = "Alternative to *fetch, uwuifies all stats";
    homepage = "https://github.com/netthier/owofetch-rs";
    license = licenses.gpl3Only;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ nullishamy ];
    mainProgram = "owofetch";
  };
}
