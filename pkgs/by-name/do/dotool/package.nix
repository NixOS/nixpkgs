{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  libxkbcommon,
  pkg-config,
  installShellFiles,
  scdoc,
}:

buildGoModule rec {
  pname = "dotool";
  version = "1.5";

  src = fetchFromSourcehut {
    owner = "~geb";
    repo = "dotool";
    rev = version;
    hash = "sha256-4QmTHeU3TnpRATKIvilkIA3i2hDjM5zQwSvmRvoWuNE=";
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
    "-X main.Version=${version}"
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
    changelog = "https://git.sr.ht/~geb/dotool/tree/${version}/item/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
