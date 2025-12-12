{
  fetchFromGitHub,
  lib,
  python3Packages,
  gtk3,
  gobject-introspection,
  wrapGAppsHook3,
  xorg,
  gnugrep,
  ghostscript,
  libnotify,
}:

python3Packages.buildPythonApplication rec {
  pname = "densify";
  version = "0.3.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "hkdb";
    repo = "Densify";
    tag = "v${version}";
    hash = "sha256-giFFy8HiSmnOqFKLyrPD1kTry8hMQxotEgD/u2FEMRY=";
  };

  postPatch = ''
    # Fix fail loading program icon from runtime path
    substituteInPlace densify \
      --replace-fail "/icon.png" "/../share/densify/icon.png"
  '';

  dependencies = with python3Packages; [ pygobject3 ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          ghostscript
          gnugrep
          xorg.xrandr
          libnotify
        ]
      }"
    )
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin densify
    install -Dm644 -t $out/share/applications densify.desktop
    install -Dm644 -t $out/share/densify desktop-icon.png icon.png

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/densify.desktop \
      --replace-fail "/opt/Densify/densify" "densify" \
      --replace-fail "Path=/opt/Densify/" "Path=$out/bin/" \
      --replace-fail "/opt/Densify/desktop-icon.png" "$out/share/densify/desktop-icon.png"
  '';

  meta = {
    description = "Compress PDF files with Ghostscript";
    homepage = "https://github.com/hkdb/Densify";
    changelog = "https://github.com/hkdb/Densify/blob/${src.rev}/README.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.all;
  };
}
