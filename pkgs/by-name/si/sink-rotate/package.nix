{ lib
, rustPlatform
, fetchFromGitHub
, pipewire
, wireplumber
, makeWrapper
}:
let
  version = "1.0.4";
in
rustPlatform.buildRustPackage {
  pname = "sink-rotate";
  inherit version;

  src = fetchFromGitHub {
    owner = "mightyiam";
    repo = "sink-rotate";
    rev = "v${version}";
    hash = "sha256-q20uUr+7yLJlZc5YgEkY125YrZ2cuJrPv5IgWXaYRlo=";
  };

  cargoHash = "sha256-MPeyPTkxpi6iw/BT5m4S7jVBD0c2zG2rsv+UZWQxpUU=";

  buildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/sink-rotate \
      --prefix PATH : ${pipewire}/bin/pw-dump \
      --prefix PATH : ${wireplumber}/bin/wpctl
  '';

  meta = with lib; {
    description = "Command that rotates default between two PipeWire audio sinks.";
    homepage = "https://github.com/mightyiam/sink-rotate";
    license = licenses.mit;
    maintainers = with maintainers; [ mightyiam ];
    mainProgram = "sink-rotate";
    platforms = platforms.linux;
  };
}

