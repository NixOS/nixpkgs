{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pipewire,
  wireplumber,
  makeWrapper,
}:
let
  version = "2.2.0";
in
rustPlatform.buildRustPackage {
  pname = "sink-rotate";
  inherit version;

  src = fetchFromGitHub {
    owner = "mightyiam";
    repo = "sink-rotate";
    rev = "v${version}";
    hash = "sha256-ZHbisG9pdctkwfD1S3kxMZhBqPw0Ni5Q9qQG4RssnSw=";
  };

  cargoHash = "sha256-TWuyU1+F3zEcFFd8ZeZmL3IvpKLLv3zimZ2WFVYFqyo=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/sink-rotate \
      --prefix PATH : ${pipewire}/bin/pw-dump \
      --prefix PATH : ${wireplumber}/bin/wpctl
  '';

  meta = {
    description = "Command that rotates the default PipeWire audio sink";
    homepage = "https://github.com/mightyiam/sink-rotate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mightyiam ];
    mainProgram = "sink-rotate";
    platforms = lib.platforms.linux;
  };
}
