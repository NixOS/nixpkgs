{
  lib,
  stdenv,
  fetchFromGitHub,
  flex,
  autoreconfHook,
  automake,
  autoconf-archive,
  libtool,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "detox";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dharple";
    repo = "detox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MMzkUh3xyyChOI1Y/mQKjnxL439mntKiMVYXuW8cPWI=";
  };

  nativeBuildInputs = [
    flex
    autoreconfHook
    automake
    autoconf-archive
    libtool
    pkg-config
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://github.com/dharple/detox";
    description = "Utility designed to clean up filenames";
    changelog = "https://github.com/dharple/detox/blob/v${finalAttrs.version}/CHANGELOG.md";
    longDescription = ''
      Detox is a utility designed to clean up filenames. It replaces
      difficult to work with characters, such as spaces, with standard
      equivalents. It will also clean up filenames with UTF-8 or Latin-1
      (or CP-1252) characters in them.
    '';
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "detox";
  };
})
