{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  cpio,
  findutils,
  gzip,
  makeWrapper,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "abootimg";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "ggrandou";
    repo = "abootimg";
    rev = "7e127fee6a3981f6b0a50ce9910267cd501e09d4";
    hash = "sha256-Kv3wItxmlKmwziKrfDAuxh1wxP5V/Pl7tI96yLtL/eE=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ util-linux ];

  postPatch = ''
    cat <<EOF > version.h
    #define VERSION_STR "${version}"
    EOF
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D -m 755 abootimg $out/bin
    install -D -m444 ./debian/abootimg.1 $out/share/man/man1/abootimg.1;

    install -D -m 755 abootimg-pack-initrd $out/bin
    wrapProgram $out/bin/abootimg-pack-initrd --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        cpio
        findutils
        gzip
      ]
    }

    install -D -m 755 abootimg-unpack-initrd $out/bin
    wrapProgram $out/bin/abootimg-unpack-initrd --prefix PATH : ${
      lib.makeBinPath [
        cpio
        gzip
      ]
    }
  '';

  meta = {
    homepage = "https://github.com/ggrandou/abootimg";
    description = "Manipulate Android Boot Images";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
