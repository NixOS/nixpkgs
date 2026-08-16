{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pipewire,
  wireplumber,
  makeWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "sink-rotate";
  version = "2.3.0-unstable-2026-05-14";

  src = fetchFromGitHub {
    owner = "mightyiam";
    repo = "sink-rotate";
    rev = "8bf24a2ebad7151fe5a7e8dd4577effccbd6fa2a";
    hash = "sha256-ftSu04fWCgZ9Beu4pMAF8KKe3nfe0km1F6ExVWbmoxQ=";
  };

  cargoHash = "sha256-qiHrntm6p3j5784Pzh0NxeyQMasTQpgsfXq+DyDqies=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/sink-rotate \
      --prefix PATH : ${pipewire}/bin/pw-dump \
      --prefix PATH : ${wireplumber}/bin/wpctl
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Command that rotates the default PipeWire audio sink";
    homepage = "https://github.com/mightyiam/sink-rotate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mightyiam ];
    mainProgram = "sink-rotate";
    platforms = lib.platforms.linux;
  };
}
