{
  lib,
  coreutils,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  extra-cmake-modules,
  dbus,
  libX11,
  libxcb,
  libXi,
  libXtst,
  libnotify,
  libxkbcommon,
  libpng,
  openssl,
  xclip,
  xdotool,
  setxkbmap,
  wl-clipboard,
  wxGTK32,
  makeWrapper,
  nix-update-script,
  stdenv,
  waylandSupport ? false,
  x11Support ? stdenv.hostPlatform.isLinux,
  testers,
}:
# espanso does not support building with both X11 and Wayland support at the same time
assert stdenv.hostPlatform.isLinux -> x11Support != waylandSupport;
assert stdenv.hostPlatform.isDarwin -> !x11Support;
assert stdenv.hostPlatform.isDarwin -> !waylandSupport;
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "espanso";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "espanso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WvFV+WZxwaGCfMVEbfHrQZS0LtgJElmOtSXK9jEeaDk=";
  };

  cargoHash = "sha256-E3z8NfKZiQsaYqDKXSIltETa4cSL0ShHnUMymjH5pas=";

  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
    makeWrapper
    wxGTK32
  ];

  # Ref: https://github.com/espanso/espanso/blob/78df1b704fe2cc5ea26f88fdc443b6ae1df8a989/scripts/build_binary.rs#LL49C3-L62C4
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "modulo"
  ]
  ++ lib.optionals waylandSupport [
    "wayland"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "vendored-tls"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "native-tls"
  ];

  buildInputs = [
    libpng
    wxGTK32
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    dbus
    libnotify
    libxkbcommon
  ]
  ++ lib.optionals waylandSupport [
    wl-clipboard
  ]
  ++ lib.optionals x11Support [
    libXi
    libXtst
    libX11
    libxcb
    xclip
    xdotool
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace scripts/create_bundle.sh \
      --replace-fail target/mac/ $out/Applications/ \
      --replace-fail /bin/echo ${coreutils}/bin/echo
    substituteInPlace espanso/src/path/macos.rs  espanso/src/path/linux.rs \
      --replace-fail '"/usr/local/bin/espanso"' '"${placeholder "out"}/bin/espanso"'
  '';

  # Some tests require networking
  doCheck = false;

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        ${stdenv.shell} ./scripts/create_bundle.sh $out/bin/espanso
      ''
    else
      ''
        wrapProgram $out/bin/espanso \
          --prefix PATH : ${
            lib.makeBinPath (
              lib.optionals stdenv.hostPlatform.isLinux [
                libnotify
                setxkbmap
              ]
              ++ lib.optionals waylandSupport [
                wl-clipboard
              ]
              ++ lib.optionals x11Support [
                xclip
              ]
            )
          }
      '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      inherit (finalAttrs) version;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    mainProgram = "espanso";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      kimat
      n8henrie
    ];
    platforms = platforms.unix;
    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
})
