{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  libxkbcommon,
  pkg-config,
  installShellFiles,
  scdoc,
}:

buildGoModule (finalAttrs: {
  pname = "dotool";
  version = "1.6";

  src = fetchFromSourcehut {
    owner = "~geb";
    repo = "dotool";
    rev = finalAttrs.version;
    hash = "sha256-KI3vA45/MvFRV8Fr3Q4yd/argDy1PpFHCT3KA9VDP80=";
  };

  vendorHash = "sha256-IQ847LHDYJPboWL/6lQNJ4vPPD/+xkrGI2LSZ7kBnp4=";

  # uses nix store path for the dotool binary
  # also replaces /bin/echo with echo
  patches = [ ./fix-paths.patch ];

  postPatch = ''
    substituteInPlace ./dotoold --replace "@dotool@" "$out/bin/dotool"
  '';

  buildInputs = [ libxkbcommon ];
  nativeBuildInputs = [
    installShellFiles
    pkg-config
    scdoc
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mkdir -p $out/bin
    cp ./dotoold ./dotoolc $out/bin
    scdoc < doc/dotool.1.scd > doc/dotool.1
    installManPage doc/dotool.1
  '';

  meta = {
    description = "Command to simulate input anywhere";
    homepage = "https://git.sr.ht/~geb/dotool";
    changelog = "https://git.sr.ht/~geb/dotool/tree/${finalAttrs.version}/item/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
