{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  networkmanager,
  libnotify,
  coreutils,
  gnused,
  gawk,
}:

let
  wrapperPath = lib.makeBinPath [
    coreutils
    libnotify
    gnused
    gawk
    networkmanager
  ];

in
stdenv.mkDerivation {
  pname = "rofi-network-manager";
  version = "0-unstable-2024-09-03";

  src = fetchFromGitHub {
    owner = "meowrch";
    repo = "rofi-network-manager";
    rev = "90302dd1c0ea2d460a3455a208c10dff524469cd";
    sha256 = "sha256-D8/Lh5a5rAUOhCXbjmL65PFzgmj3uu2mwCtxakHTefM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm 0755 network-manager.sh $out/bin/rofi-network-manager

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/rofi-network-manager \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Manage wifi and ethernet with rofi";
    homepage = "https://github.com/meowrch/rofi-network-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wenjinnn ];
    mainProgram = "rofi-network-manager";
    platforms = lib.platforms.linux;
  };
}
