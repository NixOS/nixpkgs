{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  wget,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apt-mirror";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "apt-mirror";
    repo = "apt-mirror";
    rev = finalAttrs.version;
    hash = "sha256-GNsyXP/O56Y+8QhoSfMm+ig5lK/K3Cm085jxRt9ZRmI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=''"
  ];

  postInstall = ''
    wrapProgram $out/bin/apt-mirror \
      --prefix PATH : ${lib.makeBinPath [ wget ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A tool that provides the ability to mirror any parts of apt sources";
    homepage = "https://github.com/apt-mirror/apt-mirror";
    changelog = "https://github.com/apt-mirror/apt-mirror/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "apt-mirror";
    platforms = platforms.all;
  };
})
