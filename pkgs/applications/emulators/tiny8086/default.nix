{
  lib,
  stdenv,
  fetchFromGitHub,
  localBios ? true,
  nasm,
  sdlSupport ? true,
  SDL,
}:

stdenv.mkDerivation rec {
  pname = "8086tiny";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "adriancable";
    repo = pname;
    rev = "c79ca2a34d96931d55ef724c815b289d0767ae3a";
    sha256 = "00aydg8f28sgy8l3rd2a7jvp56lx3b63hhak43p7g7vjdikv495w";
  };

  buildInputs = lib.optional localBios nasm ++ lib.optional sdlSupport SDL;

  makeFlags = [ "8086tiny" ];

  postBuild = lib.optionalString localBios ''
    pushd bios_source
    nasm -f bin bios.asm -o bios
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/8086tiny $out/share/doc/8086tiny/images
    install -m 755 8086tiny $out/bin
    install -m 644 fd.img $out/share/8086tiny/8086tiny-floppy.img
    install -m 644 bios_source/bios.asm $out/share/8086tiny/8086tiny-bios-src.asm
    install -m 644 docs/8086tiny.css $out/share/doc/8086tiny
    install -m 644 docs/doc.html $out/share/doc/$name

    for image in docs/images/\*.gif; do
      install -m 644 $image $out/share/doc/8086tiny/images
    done

    install -m 644 ${lib.optionalString localBios "bios_source/"}bios \
      $out/share/8086tiny/8086tiny-bios

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/adriancable/8086tiny";
    description = "An open-source small 8086 emulator";
    longDescription = ''
      8086tiny is a tiny, open-source (MIT), portable (little-endian hosts)
      Intel PC emulator, powerful enough to run DOS, Windows 3.0, Excel, MS
      Flight Simulator, AutoCAD, Lotus 1-2-3, and similar applications. 8086tiny
      emulates a "late 80's era" PC XT-type machine.

      8086tiny is based on an IOCCC 2013 winning entry. In fact that is the
      "unobfuscated" version :)
    '';
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
    mainProgram = "8086tiny";
  };
}
