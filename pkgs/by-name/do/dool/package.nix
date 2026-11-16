{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dool";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "scottchiefbaker";
    repo = "dool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aIGYv8UAC3toQe21xdtPUnsnrJhzbvQLfN/pPU3L2J0=";
  };

  buildInputs = [
    python3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  # fix the plugins directory
  postPatch = ''
    substituteInPlace dool \
      --replace-fail \
        "os.path.dirname(os.path.abspath(__file__)) + '/plugins/'" \
        "'$out/share/dool/'"
  '';

  meta = {
    description = "Python3 compatible clone of dstat";
    homepage = "https://github.com/scottchiefbaker/dool";
    changelog = "https://github.com/scottchiefbaker/dool/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.linux;
    mainProgram = "dool";
  };
})
