{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,

  cmake,
  installShellFiles,
  makeWrapper,
  ncurses,
  pkg-config,
  python3,
  scdoc,

  expat,
  fontconfig,
  freetype,
  libGL,
  xorg,
  libxkbcommon,
  wayland,
  xdg-utils,

  apple-sdk_11,
}:
let
  rpathLibs =
    [
      expat
      fontconfig
      freetype
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGL
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXxf86vm
      xorg.libxcb
      libxkbcommon
      wayland
    ];
in
rustPlatform.buildRustPackage rec {
  pname = "alacritty";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZhkuuxTx2y8vOfxfpDpJAyNyDdRWab0pqyDdbOCQ2XE=";
  };

  cargoHash = "sha256-T+/G2z7H/egJ/IlP3KA31jydg1CmFdLW8bLYSf/yWck=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    makeWrapper
    ncurses
    pkg-config
    python3
    scdoc
  ];

  buildInputs =
    rpathLibs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
    ];

  outputs = [
    "out"
    "terminfo"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace alacritty/src/config/ui_config.rs \
      --replace xdg-open ${xdg-utils}/bin/xdg-open
  '';

  checkFlags = [ "--skip=term::test::mock_term" ]; # broken on aarch64

  postInstall =
    (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir $out/Applications
          cp -r extra/osx/Alacritty.app $out/Applications
          ln -s $out/bin $out/Applications/Alacritty.app/Contents/MacOS
        ''
      else
        ''
          install -D extra/linux/Alacritty.desktop -t $out/share/applications/
          install -D extra/linux/org.alacritty.Alacritty.appdata.xml -t $out/share/appdata/
          install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg

          # patchelf generates an ELF that binutils' "strip" doesn't like:
          #    strip: not enough room for program headers, try linking with -N
          # As a workaround, strip manually before running patchelf.
          $STRIP -S $out/bin/alacritty

          patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
        ''
    )
    + ''
      installShellCompletion --zsh extra/completions/_alacritty
      installShellCompletion --bash extra/completions/alacritty.bash
      installShellCompletion --fish extra/completions/alacritty.fish

      install -dm 755 "$out/share/man/man1"
      install -dm 755 "$out/share/man/man5"

      scdoc < extra/man/alacritty.1.scd | gzip -c > $out/share/man/man1/alacritty.1.gz
      scdoc < extra/man/alacritty-msg.1.scd | gzip -c > $out/share/man/man1/alacritty-msg.1.gz
      scdoc < extra/man/alacritty.5.scd | gzip -c > $out/share/man/man5/alacritty.5.gz
      scdoc < extra/man/alacritty-bindings.5.scd | gzip -c > $out/share/man/man5/alacritty-bindings.5.gz

      install -dm 755 "$terminfo/share/terminfo/a/"
      tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
      mkdir -p $out/nix-support
      echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    '';

  dontPatchELF = true;

  passthru.tests.test = nixosTests.terminal-emulators.alacritty;

  meta = with lib; {
    description = "Cross-platform, GPU-accelerated terminal emulator";
    homepage = "https://github.com/alacritty/alacritty";
    license = licenses.asl20;
    mainProgram = "alacritty";
    maintainers = with maintainers; [
      Br1ght0ne
      mic92
    ];
    platforms = platforms.unix;
    changelog = "https://github.com/alacritty/alacritty/blob/v${version}/CHANGELOG.md";
  };
}
