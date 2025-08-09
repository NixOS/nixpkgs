{
  lib,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  rust-analyzer,
}:

rustPlatform.buildRustPackage rec {
  pname = "ra-multiplex";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "pr2502";
    repo = "ra-multiplex";
    rev = "v${version}";
    hash = "sha256-aBrn9g+MGXLAsOmHqw1Tt6NPFGJTyYv/L9UI/vQU4i8=";
  };

  cargoHash = "sha256-NVE/ROk6x1R0D5eyOzz1gYPvgG0lX5L2tCuZGIS9kzs=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ra-multiplex \
      --suffix PATH : ${lib.makeBinPath [ rust-analyzer ]}
  '';

  meta = with lib; {
    description = "Multiplexer for rust-analyzer";
    mainProgram = "ra-multiplex";
    homepage = "https://github.com/pr2502/ra-multiplex";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ norfair ];
  };
}
