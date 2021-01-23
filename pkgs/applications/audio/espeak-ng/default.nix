{ stdenv, lib, fetchFromGitHub, autoconf, automake, which, libtool, pkg-config
, ronn
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

  nativeBuildInputs = [ autoconf automake which libtool pkg-config ronn ];

  buildInputs = lib.optional pcaudiolibSupport pcaudiolib
             ++ lib.optional sonicSupport sonic;

  preConfigure = "./autogen.sh";

  postInstall = lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/espeak-ng)" $out/bin/speak-ng
  '';

  meta = with lib; {
    description = "Open source speech synthesizer that supports over 70 languages, based on eSpeak";
    homepage = "https://github.com/espeak-ng/espeak-ng";
    changelog = "https://github.com/espeak-ng/espeak-ng/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.all;
  };
}
