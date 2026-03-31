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
  version = "0.12.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LGFae";
    repo = "awww";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bvO+gfuUOVUiBEwAJ5A2RjpysPzCfyXD+DM8piOa1+4=";
  };

  cargoHash = "sha256-4ApaMiVqXD4RlyWFMk2wKsyo37FT/OeVly/H88pF7oc=";

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
