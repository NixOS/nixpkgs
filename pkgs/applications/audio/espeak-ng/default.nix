{ stdenv, lib, fetchFromGitHub, autoconf, automake, which, libtool, pkg-config
, ronn, substituteAll
, mbrolaSupport ? true, mbrola
, pcaudiolibSupport ? true, pcaudiolib
, sonicSupport ? true, sonic }:

stdenv.mkDerivation rec {
  pname = "espeak-ng";
  version = "1.50";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = version;
    sha256 = "0jkqhf2h94vbqq7mg7mmm23bq372fa7mdk941my18c3vkldcir1b";
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

  meta = with lib; {
    description = "Open source speech synthesizer that supports over 70 languages, based on eSpeak";
    homepage = "https://github.com/espeak-ng/espeak-ng";
    changelog = "https://github.com/espeak-ng/espeak-ng/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.all;
  };
}
