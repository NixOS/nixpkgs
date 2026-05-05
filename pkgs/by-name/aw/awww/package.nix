{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  lz4,
  libxkbcommon,
  installShellFiles,
  makeWrapper,
  procps,
  scdoc,
  wayland-protocols,
  wayland-scanner,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "awww";
  version = "0.12.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LGFae";
    repo = "awww";
    tag = "v${finalAttrs.version}";
    hash = "sha256-owyQdC2vi0kYC119fzyVQp0J4G0t1n4xXUwryhlBbqA=";
  };

  cargoHash = "sha256-huw9vzLzXE7eu1ksB6a/SJAtp4xLc2hDb0RHS8O28MY=";

  buildInputs = [
    lz4
    libxkbcommon
    wayland-protocols
    wayland-scanner
  ];

  doCheck = false; # Integration tests do not work in sandbox environment

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
    scdoc
  ];

  postInstall = ''
    for f in doc/*.scd; do
      local page="doc/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    installShellCompletion --cmd awww \
      --bash completions/awww.bash \
      --fish completions/awww.fish \
      --zsh completions/_awww
  '';

  postFixup = ''
    for program in $out/bin/*; do
      wrapProgram $program \
        --prefix PATH : "${lib.makeBinPath [ procps ]}"
    done
  '';

  meta = {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://codeberg.org/LGFae/awww";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mateodd25
      donovanglover
    ];
    platforms = lib.platforms.linux;
    mainProgram = "awww";
  };
})
