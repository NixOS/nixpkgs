{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sacd";
  version = "19.7.16.37";

  src = fetchFromGitHub {
    owner = "Sound-Linux-More";
    repo = "sacd";
    rev = finalAttrs.version;
    sha256 = "03s7jr75pzqj1xd41rkgbszlgf9zx6vzhd0nizc05wyf0fxq5xif";
  };

  patches = [
    # Makefile prefix, otherwise `/usr` prefix is enforced
    # https://github.com/Sound-Linux-More/sacd/pull/1
    (fetchpatch {
      url = "https://github.com/Sound-Linux-More/sacd/commit/a72def4fab234bcd68b444cf7447a8876b4e2ce8.patch";
      name = "makefile-prefix.patch";
      sha256 = "0a7r4x0yqpg6l4vr84dq4wbrypabqm4vvcjv91am068gqjiw6w64";
    })
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    description = "Converts SACD image files, Philips DSDIFF and Sony DSF files to 24-bit high resolution wave files. Handles both DST and DSD streams";
    longDescription = ''
      Super Audio CD decoder. Converts SACD image files, Philips DSDIFF and Sony DSF files to 24-bit high resolution wave files.
      Handles both DST and DSD streams.
    '';
    homepage = "https://github.com/Sound-Linux-More/sacd";
    license = licenses.gpl3;
    maintainers = [ maintainers.doronbehar ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sacd";
  };
})
