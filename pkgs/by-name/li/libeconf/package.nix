{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libeconf";
  version = "0.8.3";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libeconf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZXZcXQdG3hXAMwwftrIWL5GbVdPXk+AyqdhGTnaKL1I=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    chmod +x tests/*.sh
    patchShebangs tests/
  '';

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  meta = {
    description = "Enhanced config file parser which merges config files placed in several locations into one";
    changelog = "https://github.com/openSUSE/libeconf/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/openSUSE/libeconf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ port22exposed ];
    mainProgram = "econftool";
    platforms = lib.platforms.linux;
  };
})
