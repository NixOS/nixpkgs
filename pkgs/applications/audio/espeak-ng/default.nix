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
, mbrolaSupport ? true
, mbrola
, pcaudiolibSupport ? true
, pcaudiolib
, sonicSupport ? true
, sonic
}:

stdenv.mkDerivation rec {
  pname = "espeak-ng";
  version = "1.51";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = version;
    hash = "sha256-KwzMlQ3/JgpNOpuV4zNc0zG9oWEGFbVSJ4bEd3dtD3Y=";
  };

  patches = lib.optionals mbrolaSupport [
    # Hardcode correct mbrola paths.
    (substituteAll {
      src = ./mbrola.patch;
      inherit mbrola;
    })
  ];

  nativeBuildInputs = [ autoconf automake which libtool pkg-config ronn ];

  buildInputs = lib.optional mbrolaSupport mbrola
    ++ lib.optional pcaudiolibSupport pcaudiolib
    ++ lib.optional sonicSupport sonic;

  preConfigure = "./autogen.sh";

  configureFlags = [
    "--with-mbrola=${if mbrolaSupport then "yes" else "no"}"
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/espeak-ng)" $out/bin/speak-ng
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
  };
}
