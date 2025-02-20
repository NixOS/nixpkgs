{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  rofi,
  rofi-wayland,
  networkmanager,
  libnotify,
  coreutils,
  gnused,
  gawk,
  backend ? "x11",
}:

assert lib.assertOneOf "backend" backend [
  "x11"
  "wayland"
];

let
  wrapperPath = lib.makeBinPath (
    [
      coreutils
      libnotify
      gnused
      gawk
      networkmanager
    ]
    ++ lib.optionals (backend == "x11") [
      rofi
    ]
    ++ lib.optionals (backend == "wayland") [
      rofi-wayland
    ]
  );

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
    install -Dm 0755 network-manager.sh $out/bin/rofi-network-manager
  '';

  postFixup = ''
    substituteInPlace $out/bin/rofi-network-manager \
      --replace-fail "sudo " "/run/wrappers/bin/sudo "

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
