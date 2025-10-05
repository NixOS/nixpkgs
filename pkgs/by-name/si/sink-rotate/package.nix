{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pipewire,
  wireplumber,
  makeWrapper,
}:
let
  version = "2.3.0";
in
rustPlatform.buildRustPackage {
  pname = "sink-rotate";
  inherit version;

  src = fetchFromGitHub {
    owner = "mightyiam";
    repo = "sink-rotate";
    rev = "v${version}";
    hash = "sha256-gGmnji7KqmCxUaeXOGMnHMI6b8AJ6Np+xVjibqgGSKM=";
  };

  cargoHash = "sha256-7/EyDBWANoL5m9mx93LKMKD8hgcc3VgvrcLD6oTBXN8=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/sink-rotate \
      --prefix PATH : ${pipewire}/bin/pw-dump \
      --prefix PATH : ${wireplumber}/bin/wpctl
  '';

  meta = with lib; {
    description = "Command that rotates the default PipeWire audio sink";
    homepage = "https://github.com/mightyiam/sink-rotate";
    license = licenses.mit;
    maintainers = with maintainers; [ mightyiam ];
    mainProgram = "sink-rotate";
    platforms = platforms.linux;
  };
}
