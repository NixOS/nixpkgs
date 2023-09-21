{ stdenv
, lib
, fetchFromGitHub
, autoconf
, automake
, which
, libtool
, pkg-config
, ronn
, substituteAll
, buildPackages
, mbrolaSupport ? true
, mbrola
, pcaudiolibSupport ? true
, pcaudiolib
, sonicSupport ? true
, sonic
, alsa-plugins
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "espeak-ng";
  version = "1.51.1";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = version;
    hash = "sha256-aAJ+k+kkOS6k835mEW7BvgAIYGhUHxf7Q4P5cKO8XTk=";
  };

  patches = lib.optionals mbrolaSupport [
    # Hardcode correct mbrola paths.
    (substituteAll {
      src = ./mbrola.patch;
      inherit mbrola;
    })
  ];

  nativeBuildInputs = [ autoconf automake which libtool pkg-config ronn makeWrapper ];

  buildInputs = lib.optional mbrolaSupport mbrola
    ++ lib.optional pcaudiolibSupport pcaudiolib
    ++ lib.optional sonicSupport sonic;

  preConfigure = "./autogen.sh";

  configureFlags = [
    "--with-mbrola=${if mbrolaSupport then "yes" else "no"}"
  ];

  # ref https://github.com/void-linux/void-packages/blob/3cf863f894b67b3c93e23ac7830ca46b697d308a/srcpkgs/espeak-ng/template#L29-L31
  postConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace Makefile \
      --replace 'ESPEAK_DATA_PATH=$(CURDIR) src/espeak-ng' 'ESPEAK_DATA_PATH=$(CURDIR) ${lib.getExe buildPackages.espeak-ng}' \
      --replace 'espeak-ng-data/%_dict: src/espeak-ng' 'espeak-ng-data/%_dict: ${lib.getExe buildPackages.espeak-ng}' \
      --replace '../src/espeak-ng --compile' "${lib.getExe buildPackages.espeak-ng} --compile"
  '';

  postInstall = lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/espeak-ng)" $out/bin/speak-ng
    wrapProgram $out/bin/espeak-ng \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
  '';

  passthru = {
    inherit mbrolaSupport;
  };

  meta = with lib; {
    description = "Open source speech synthesizer that supports over 70 languages, based on eSpeak";
    homepage = "https://github.com/espeak-ng/espeak-ng";
    changelog = "https://github.com/espeak-ng/espeak-ng/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.all;
    mainProgram = "espeak-ng";
  };
}
