{
  lib,
  stdenv,
  fetchFromGitLab,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stegsnow";
  version = "20130616-8";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "pkg-security-team";
    repo = "stegsnow";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-5GmU2HfWSLJ8DwjZZmWW277rJhA73is6606YZAKo4r8=";
  };

  postPatch = ''
    for i in $(cat debian/patches/series); do
      patch -p1 < "debian/patches/$i"
    done

    substituteInPlace Makefile \
      --replace-fail 'snow:' 'stegsnow:' \

    mv snow.1 stegsnow.1
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 stegsnow $out/bin/stegsnow
    install -Dm644 stegsnow.1 $out/share/man/man1/stegsnow.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Conceal messages in ASCII text by appending whitespace to the end of lines";
    # Long description via homepage
    longDescription = ''
      The program SNOW is used to conceal messages in ASCII text by appending whitespace to the end of lines.
      Because spaces and tabs are generally not visible in text viewers, the message is effectively hidden from casual observers.
      And if the built-in encryption is used, the message cannot be read even if it is detected.
    '';
    homepage = "https://darkside.com.au/snow/";
    license = licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with maintainers; [ nikitawootten ];
    mainProgram = "stegsnow";
  };
})
