{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  glib,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nautilus-my-computer";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "yannmasoch";
    repo = "nautilus-my-computer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UW1BqLQItzjpcALXzu+Zgr3He0XFYTcDmbFvW5lCVKo=";
  };

  patches = [ ./hardcode-gsettings.patch ];

  postPatch = ''
    substituteInPlace nautilus_my_computer/main.py \
      --subst-var-by gsettings_path ${glib.makeSchemaPath "$out" "$name"}
    substituteInPlace nautilus-my-computer.py \
      --replace-fail 'sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))' \
        'sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    sys.path.append("${python3.pkgs.pycairo}/${python3.sitePackages}")'
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gettext
    glib
    python3
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nautilus extension that adds a Computer view with drives, partitions and network locations";
    homepage = "https://github.com/yannmasoch/nautilus-my-computer";
    changelog = "https://github.com/yannmasoch/nautilus-my-computer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bittner
      yannmasoch
    ];
    platforms = lib.platforms.linux;
  };
})
